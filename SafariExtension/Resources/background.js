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
    
    // Set up native messaging first (if available)
    setupNativeMessaging();
    
    // Load initial data
    loadDataFromStorage();
    
    // Set up periodic data sync (reduced frequency when native messaging is available)
    const syncInterval = nativePort ? 10000 : 2000; // 10 seconds with native messaging, 2 seconds without
    setInterval(loadDataFromStorage, syncInterval);
    
    // Set up timer check for unshielded websites expiration
    setInterval(checkUnshieldedTimers, 1000); // Check every second
}

// Load data from Safari extension storage (UserDefaults)
async function loadDataFromStorage() {
    try {
        console.log('Life Shield: Attempting to load data from storage...');
        
        // For Safari extensions, native messaging works differently
        // The background script should request data from the native app through the extension's native messaging
        
        // Try Safari Web Extension native messaging (if available)
        if (typeof browser !== 'undefined' && browser.runtime && browser.runtime.connectNative) {
            try {
                console.log('Life Shield: Attempting Safari Web Extension native messaging');
                // This is the correct way for Safari Web Extensions
                const port = browser.runtime.connectNative('com.project7iii.life.extension');
                port.postMessage({ type: 'getData' });
                
                port.onMessage.addListener((response) => {
                    console.log('Life Shield: Received response from native app:', response);
                    handleNativeMessage(response);
                });
                
                port.onDisconnect.addListener(() => {
                    console.log('Life Shield: Native messaging port disconnected');
                });
            } catch (nativeError) {
                console.log('Life Shield: Safari native messaging failed:', nativeError);
            }
        } else {
            console.log('Life Shield: Safari native messaging not available');
        }
        
        console.log('Life Shield: Loading from local storage (primary data source)');
        
        // Always try to load from local storage as fallback
        try {
            const stored = await browser.storage.local.get([
                STORAGE_KEYS.BLOCKED_WEBSITES,
                STORAGE_KEYS.TOP_UP_ACTIVE,
                STORAGE_KEYS.TOP_UP_MINUTES,
                STORAGE_KEYS.UNSHIELDED_WEBSITES
            ]);
            
            console.log('Life Shield: Loaded from storage:', stored);
            
            const newBlockedWebsites = stored[STORAGE_KEYS.BLOCKED_WEBSITES] || [];
            const newTopUpActive = stored[STORAGE_KEYS.TOP_UP_ACTIVE] || false;
            const newTopUpMinutes = stored[STORAGE_KEYS.TOP_UP_MINUTES] || 1;
            const newUnshieldedWebsites = stored[STORAGE_KEYS.UNSHIELDED_WEBSITES] || {};
            
            // Check if data changed
            const websitesChanged = JSON.stringify(blockedWebsites) !== JSON.stringify(newBlockedWebsites);
            const topUpActiveChanged = topUpActive !== newTopUpActive;
            const topUpMinutesChanged = topUpMinutes !== newTopUpMinutes;
            const unshieldedChanged = JSON.stringify(unshieldedWebsites) !== JSON.stringify(newUnshieldedWebsites);
            
            if (websitesChanged || topUpActiveChanged || topUpMinutesChanged || unshieldedChanged) {
                console.log('Life Shield: Data changed, updating...');
                blockedWebsites = newBlockedWebsites;
                topUpActive = newTopUpActive;
                topUpMinutes = newTopUpMinutes;
                unshieldedWebsites = newUnshieldedWebsites;
                
                // Notify all content scripts of the update
                notifyContentScripts();
            }
        } catch (storageError) {
            console.log('Life Shield: Error loading from local storage:', storageError);
        }
        
    } catch (error) {
        console.log('Life Shield: Error in loadDataFromStorage:', error);
    }
}

// Check if unshielded timers have expired
function checkUnshieldedTimers() {
    const currentTime = Date.now();
    let hasExpired = false;
    
    // Check each unshielded website
    for (const [domain, endTime] of Object.entries(unshieldedWebsites)) {
        if (currentTime > endTime) {
            console.log(`Life Shield: Timer expired for domain: ${domain}`);
            delete unshieldedWebsites[domain];
            hasExpired = true;
        }
    }
    
    // If any timers expired, update storage and notify content scripts
    if (hasExpired) {
        console.log('Life Shield: Timers expired, updating storage');
        saveUnshieldedWebsites();
        notifyContentScripts();
    }
}

// Save unshielded websites to local storage
async function saveUnshieldedWebsites() {
    try {
        console.log('Life Shield: Saving unshielded websites:', unshieldedWebsites);
        await browser.storage.local.set({
            [STORAGE_KEYS.UNSHIELDED_WEBSITES]: unshieldedWebsites
        });
    } catch (error) {
        console.log('Life Shield: Error saving unshielded websites:', error);
    }
}

// Save all data to storage (for when we get updates from native app)
async function saveAllDataToStorage() {
    try {
        console.log('Life Shield: Saving all data to storage');
        await browser.storage.local.set({
            [STORAGE_KEYS.BLOCKED_WEBSITES]: blockedWebsites,
            [STORAGE_KEYS.TOP_UP_ACTIVE]: topUpActive,
            [STORAGE_KEYS.TOP_UP_MINUTES]: topUpMinutes,
            [STORAGE_KEYS.UNSHIELDED_WEBSITES]: unshieldedWebsites
        });
        console.log('Life Shield: Data saved successfully');
    } catch (error) {
        console.log('Life Shield: Error saving data to storage:', error);
    }
}

// Handle messages from native app (Safari-specific)
function handleNativeMessage(data) {
    console.log('Life Shield: Received message from native app:', data);
    
    if (data && data.type === 'dataResponse') {
        const newBlockedWebsites = data.blockedWebsites || [];
        const newTopUpActive = data.topUpActive || false;
        const newTopUpMinutes = data.topUpMinutes || 1;
        
        // Check if data changed
        const websitesChanged = JSON.stringify(blockedWebsites) !== JSON.stringify(newBlockedWebsites);
        const topUpActiveChanged = topUpActive !== newTopUpActive;
        const topUpMinutesChanged = topUpMinutes !== newTopUpMinutes;
        
        if (websitesChanged || topUpActiveChanged || topUpMinutesChanged) {
            console.log('Life Shield: Native app data changed, updating...');
            blockedWebsites = newBlockedWebsites;
            topUpActive = newTopUpActive;
            topUpMinutes = newTopUpMinutes;
            
            // Save to storage and notify content scripts
            saveAllDataToStorage();
            notifyContentScripts();
        }
    }
}

// Set up native messaging connection (Safari Web Extensions)
let nativePort = null;

function setupNativeMessaging() {
    if (typeof browser !== 'undefined' && browser.runtime && browser.runtime.connectNative) {
        try {
            console.log('Life Shield: Setting up native messaging connection');
            nativePort = browser.runtime.connectNative('com.project7iii.life.extension');
            
            nativePort.onMessage.addListener((response) => {
                console.log('Life Shield: Native message received:', response);
                handleNativeMessage(response);
            });
            
            nativePort.onDisconnect.addListener(() => {
                console.log('Life Shield: Native messaging disconnected');
                nativePort = null;
                // Try to reconnect after a delay
                setTimeout(setupNativeMessaging, 5000);
            });
            
            // Request initial data
            nativePort.postMessage({ type: 'getData' });
            
        } catch (error) {
            console.log('Life Shield: Failed to setup native messaging:', error);
            nativePort = null;
        }
    }
}

// Send message to native app
function sendToNativeApp(message) {
    if (nativePort) {
        try {
            console.log('Life Shield: Sending message to native app:', message);
            nativePort.postMessage(message);
            return Promise.resolve({ success: true });
        } catch (error) {
            console.log('Life Shield: Error sending to native app:', error);
            return Promise.resolve({ success: false, error: error.message });
        }
    } else {
        console.log('Life Shield: No native messaging connection available');
        return Promise.resolve({ success: false, error: 'No native connection' });
    }
}

// Notify all content scripts of data updates
function notifyContentScripts() {
    console.log('Life Shield: Notifying content scripts');
    browser.tabs.query({}, (tabs) => {
        console.log(`Life Shield: Found ${tabs.length} tabs to notify`);
        tabs.forEach(tab => {
            browser.tabs.sendMessage(tab.id, {
                type: 'statusUpdate'
            }).catch((error) => {
                // Ignore errors for tabs that don't have our content script
                console.log(`Life Shield: Could not send message to tab ${tab.id}:`, error);
            });
        });
    });
}

// Check if website should be blocked
function isWebsiteBlocked(domain) {
    const blocked = blockedWebsites.some(blockedWebsite => {
        // Exact match or subdomain match
        return domain === blockedWebsite || domain.endsWith('.' + blockedWebsite);
    });
    console.log(`Life Shield: Domain ${domain} blocked status: ${blocked}`);
    return blocked;
}

// Check if website is currently unshielded
function isWebsiteUnshielded(domain) {
    const endTime = unshieldedWebsites[domain];
    const unshielded = endTime && Date.now() < endTime;
    console.log(`Life Shield: Domain ${domain} unshielded status: ${unshielded}`);
    return unshielded;
}

// Get remaining unshielded time for a website in seconds
function getRemainingUnshieldTime(domain) {
    const endTime = unshieldedWebsites[domain];
    if (!endTime) return 0;
    const remaining = Math.max(0, Math.floor((endTime - Date.now()) / 1000));
    console.log(`Life Shield: Domain ${domain} remaining time: ${remaining}s`);
    return remaining;
}

// Add website to unshielded list
function addWebsiteToUnshielded(domain) {
    console.log(`Life Shield: Adding ${domain} to unshielded list for ${topUpMinutes} minutes`);
    const durationMs = topUpMinutes * 60 * 1000; // Convert minutes to milliseconds
    const endTime = Date.now() + durationMs;
    unshieldedWebsites[domain] = endTime;
    saveUnshieldedWebsites();
    notifyContentScripts();
}

// Handle messages from content scripts
browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
    console.log('Life Shield: Background received message:', message);
    
    switch (message.type) {
        case 'getBlockingStatus':
            const domain = message.domain;
            const shouldBlock = isWebsiteBlocked(domain);
            const isUnshielded = isWebsiteUnshielded(domain);
            const remainingTime = getRemainingUnshieldTime(domain);
            
            const response = {
                shouldBlock,
                isUnshielded,
                topUpActive,
                topUpMinutes,
                remainingTime
            };
            
            console.log('Life Shield: Sending blocking status response:', response);
            sendResponse(response);
            break;
            
        case 'requestTopUp':
            const topUpDomain = message.domain;
            console.log(`Life Shield: Top-up requested for domain: ${topUpDomain}`);
            
            // Add website to unshielded list
            addWebsiteToUnshielded(topUpDomain);
            
            // Send response back to content script
            browser.tabs.sendMessage(sender.tab.id, {
                type: 'topUpResponse',
                success: true,
                domain: topUpDomain,
                duration: topUpMinutes
            }).then(() => {
                console.log('Life Shield: Top-up response sent successfully');
            }).catch((error) => {
                console.log('Life Shield: Error sending top-up response:', error);
            });
            break;
            
        default:
            console.log('Life Shield: Unknown message type:', message.type);
    }
    
    // Return true to indicate we'll send a response asynchronously
    return true;
});

// Handle extension installation/startup
browser.runtime.onStartup.addListener(() => {
    console.log('Life Shield: Extension startup');
    init();
});

browser.runtime.onInstalled.addListener(() => {
    console.log('Life Shield: Extension installed');
    init();
});

// Initialize immediately
console.log('Life Shield: Initializing background script');
init();
