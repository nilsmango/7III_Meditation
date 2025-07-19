
let blockedWebsites = [];
let topUpActive = false;
let topUpMinutes = 1;
let unshieldedWebsites = {}; // { domain: endTimestamp }
let checkTimer = null;

// Constants
const STORAGE_KEYS = {
    BLOCKED_WEBSITES: 'blockedWebsites',
    TOP_UP_ACTIVE: 'topUpActive',
    TOP_UP_MINUTES: 'topUpMinutes',
    UNSHIELDED_WEBSITES: 'unshieldedWebsites'
};

const APP_GROUP_ID = 'group.com.project7iii.life';

// Initialize background script
function init() {
    console.log('Life Shield background script initialized');
    
    // Load initial data
    loadDataFromStorage();
    
    // Set up periodic data sync
    setInterval(loadDataFromStorage, 2000); // Check every 2 seconds
    
    // Set up timer check for unshielded websites expiration
    setInterval(checkUnshieldedTimers, 1000); // Check every second
}

// Load data from Safari extension storage (UserDefaults)
async function loadDataFromStorage() {
    try {
        // Try to get data from Safari extension's UserDefaults via native messaging
        const response = await browser.runtime.sendNativeMessage('com.project7iii.life.extension', {
            type: 'getData'
        });
        
        if (response && response.success) {
            const newBlockedWebsites = response.blockedWebsites || [];
            const newTopUpActive = response.topUpActive || false;
            const newTopUpMinutes = response.topUpMinutes || 1;
            
            // Check if data changed
            const websitesChanged = JSON.stringify(blockedWebsites) !== JSON.stringify(newBlockedWebsites);
            const topUpActiveChanged = topUpActive !== newTopUpActive;
            const topUpMinutesChanged = topUpMinutes !== newTopUpMinutes;
            
            if (websitesChanged || topUpActiveChanged || topUpMinutesChanged) {
                blockedWebsites = newBlockedWebsites;
                topUpActive = newTopUpActive;
                topUpMinutes = newTopUpMinutes;
                
                // Notify all content scripts of the update
                notifyContentScripts();
            }
        }
        
        // Always load unshielded websites from local storage (extension-specific data)
        const stored = await browser.storage.local.get([STORAGE_KEYS.UNSHIELDED_WEBSITES]);
        unshieldedWebsites = stored[STORAGE_KEYS.UNSHIELDED_WEBSITES] || {};
        
    } catch (error) {
        console.log('Life Shield: Error loading data from native app:', error);
        
        // Fallback: try to load everything from local storage
        try {
            const stored = await browser.storage.local.get([
                STORAGE_KEYS.BLOCKED_WEBSITES,
                STORAGE_KEYS.TOP_UP_ACTIVE,
                STORAGE_KEYS.TOP_UP_MINUTES,
                STORAGE_KEYS.UNSHIELDED_WEBSITES
            ]);
            
            blockedWebsites = stored[STORAGE_KEYS.BLOCKED_WEBSITES] || [];
            topUpActive = stored[STORAGE_KEYS.TOP_UP_ACTIVE] || false;
            topUpMinutes = stored[STORAGE_KEYS.TOP_UP_MINUTES] || 1;
            unshieldedWebsites = stored[STORAGE_KEYS.UNSHIELDED_WEBSITES] || {};
        } catch (storageError) {
            console.log('Life Shield: Error loading from storage:', storageError);
        }
    }
}

// Check if unshielded timers have expired
function checkUnshieldedTimers() {
    const currentTime = Date.now();
    let hasExpired = false;
    
    // Check each unshielded website
    for (const [domain, endTime] of Object.entries(unshieldedWebsites)) {
        if (currentTime > endTime) {
            delete unshieldedWebsites[domain];
            hasExpired = true;
        }
    }
    
    // If any timers expired, update storage and notify content scripts
    if (hasExpired) {
        saveUnshieldedWebsites();
        notifyContentScripts();
    }
}

// Save unshielded websites to local storage
async function saveUnshieldedWebsites() {
    try {
        await browser.storage.local.set({
            [STORAGE_KEYS.UNSHIELDED_WEBSITES]: unshieldedWebsites
        });
    } catch (error) {
        console.log('Life Shield: Error saving unshielded websites:', error);
    }
}

// Send message to native app
async function sendToNativeApp(message) {
    try {
        const response = await browser.runtime.sendNativeMessage('com.project7iii.life.extension', message);
        return response;
    } catch (error) {
        console.log('Life Shield: Error sending to native app:', error);
        return { success: false, error: error.message };
    }
}

// Notify all content scripts of data updates
function notifyContentScripts() {
    browser.tabs.query({}, (tabs) => {
        tabs.forEach(tab => {
            browser.tabs.sendMessage(tab.id, {
                type: 'statusUpdate'
            }).catch(() => {
                // Ignore errors for tabs that don't have our content script
            });
        });
    });
}

// Check if website should be blocked
function isWebsiteBlocked(domain) {
    return blockedWebsites.some(blockedWebsite => {
        // Exact match or subdomain match
        return domain === blockedWebsite || domain.endsWith('.' + blockedWebsite);
    });
}

// Check if website is currently unshielded
function isWebsiteUnshielded(domain) {
    const endTime = unshieldedWebsites[domain];
    return endTime && Date.now() < endTime;
}

// Get remaining unshielded time for a website in seconds
function getRemainingUnshieldTime(domain) {
    const endTime = unshieldedWebsites[domain];
    if (!endTime) return 0;
    const remaining = Math.max(0, Math.floor((endTime - Date.now()) / 1000));
    return remaining;
}

// Add website to unshielded list
function addWebsiteToUnshielded(domain) {
    const durationMs = topUpMinutes * 60 * 1000; // Convert minutes to milliseconds
    const endTime = Date.now() + durationMs;
    unshieldedWebsites[domain] = endTime;
    saveUnshieldedWebsites();
    notifyContentScripts();
}

// Handle messages from content scripts
browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
    switch (message.type) {
        case 'getBlockingStatus':
            const domain = message.domain;
            const shouldBlock = isWebsiteBlocked(domain);
            const isUnshielded = isWebsiteUnshielded(domain);
            const remainingTime = getRemainingUnshieldTime(domain);
            
            sendResponse({
                shouldBlock,
                isUnshielded,
                topUpActive,
                topUpMinutes,
                remainingTime
            });
            break;
            
        case 'requestTopUp':
            const topUpDomain = message.domain;
            
            // Add website to unshielded list
            addWebsiteToUnshielded(topUpDomain);
            
            // Send response back to content script
            browser.tabs.sendMessage(sender.tab.id, {
                type: 'topUpResponse',
                success: true,
                domain: topUpDomain,
                duration: topUpMinutes
            });
            break;
    }
    
    // Return true to indicate we'll send a response asynchronously
    return true;
});

// Handle extension installation/startup
browser.runtime.onStartup.addListener(init);
browser.runtime.onInstalled.addListener(init);

// Initialize immediately
init();
