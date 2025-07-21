
function showWebsiteShield(websites, topUpActive, topUpMinutes) {
    // Remove any existing overlay
    const existingOverlay = document.getElementById('7iii-life-overlay');
    if (existingOverlay) {
        existingOverlay.remove();
    }

    // Detect dark mode
    const isDarkMode = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches;
    
    // Create main overlay container with enhanced positioning
    const overlay = document.createElement("div");
    overlay.id = '7iii-life-overlay';
    
    // Create backdrop div that ensures full coverage
    const backdrop = document.createElement("div");
    Object.assign(backdrop.style, {
        position: "fixed",
        top: "0",
        left: "0",
        right: "0",
        bottom: "0",
        width: "100vw",
        height: "100vh",
        margin: "0",
        padding: "0",
        backgroundColor: isDarkMode ? "rgba(28, 28, 30, 0.8)" : "rgba(248, 248, 248, 0.8)",
        backdropFilter: "blur(20px)",
        webkitBackdropFilter: "blur(20px)",
        zIndex: "2147483647" // Maximum z-index value
    });
    
    // Create content container
    const content = document.createElement("div");
    
    // Create circle icon
    const circle = document.createElement("div");
    circle.innerHTML = "○";
    Object.assign(circle.style, {
        fontSize: "150px",
        fontWeight: "300",
        height: "150px",
        lineHeight: "150px",
        marginBottom: "7px",
        color: isDarkMode ? "#ffffff" : "#000000"
    });
    
    // Create title
    const title = document.createElement("h1");
    title.textContent = "Blocked by 7III Life";
    Object.assign(title.style, {
        fontSize: "28px",
        fontWeight: "600",
        margin: "0 0 15px 0",
        color: isDarkMode ? "#ffffff" : "#000000"
    });
    
    // Create subtitle
    const subtitle = document.createElement("p");
    if (topUpActive !== undefined) {
        if (topUpActive) {
            subtitle.textContent = "This app is currently blocked.";
        } else {
            subtitle.textContent = "This app is currently blocked, if you need more time, go to 7Ill Life to unlock more time.";
        }
    }
    
    Object.assign(subtitle.style, {
        fontSize: "16px",
        margin: "0 0 120px 0",
        color: isDarkMode ? "#b0b0b0" : "#666666",
        fontWeight: "400"
    });
    
    // Create OK button
    const okButton = document.createElement("button");
    okButton.textContent = "OK";
    Object.assign(okButton.style, {
        backgroundColor: isDarkMode ? "#62A453" : "#7BCB65",
        color: "white",
        border: "none",
        borderRadius: "25px",
        padding: "15px 40px",
        fontSize: "16px",
        fontWeight: "500",
        cursor: "pointer",
        marginBottom: "0px",
        minWidth: "150px",
        transition: "all 0.2s ease"
    });
    
    // OK button hover effect
    okButton.addEventListener('mouseenter', () => {
        okButton.style.backgroundColor = "#45a049";
        okButton.style.transform = "scale(1.02)";
    });
    
    okButton.addEventListener('mouseleave', () => {
        okButton.style.backgroundColor = isDarkMode ? "#62A453" : "#7BCB65";
        okButton.style.transform = "scale(1)";
    });
    
    // OK button click handler - close Safari/window
    okButton.addEventListener('click', () => {
        browser.runtime.sendMessage({ action: 'close-tab' });
    });
    
    // Create top-up button (only if available)
    let topUpButton = null;
    if (topUpActive !== undefined) {
        
        if (topUpActive && topUpMinutes > 0) {
        topUpButton = document.createElement("button");
        
            topUpButton.textContent = `Unlock for ${topUpMinutes} min`;
            topUpButton.style.backgroundColor = "transparent";
            topUpButton.style.color = isDarkMode ? "#ffffff" : "#000000";
            topUpButton.style.cursor = "pointer";
            
            // Top-up button hover effect
            topUpButton.addEventListener('mouseenter', () => {
                topUpButton.style.color = isDarkMode ? "#62A453" : "#7BCB65";
            });
            
            topUpButton.addEventListener('mouseleave', () => {
                topUpButton.style.color = isDarkMode ? "#ffffff" : "#000000";
            });
            
            // Top-up click handler
            topUpButton.addEventListener('click', () => {
                removeWebsite(topUpMinutes);
            });
        
        
        Object.assign(topUpButton.style, {
            border: "none",
            borderRadius: "25px",
            padding: "12px 12px",
            fontSize: "16px",
            fontWeight: "400",
            minWidth: "300px",
            transition: "all 0.2s ease"
        });
        }
    }
    
    // Assemble content
    content.appendChild(circle);
    content.appendChild(title);
    content.appendChild(subtitle);
    content.appendChild(okButton);
    
    if (topUpButton) {
        content.appendChild(topUpButton);
    }
    
    // Style content container (no background - backdrop handles it)
    Object.assign(content.style, {
        textAlign: "center",
        padding: "40px",
        maxWidth: "400px",
        margin: "0 20px", // Add some margin for mobile
        position: "relative",
        zIndex: "2147483647",
        backgroundColor: "transparent" // Remove the old background
    });
    
    // Style main overlay container
    Object.assign(overlay.style, {
        position: "fixed",
        top: "0",
        left: "0",
        right: "0",
        bottom: "0",
        width: "100vw",
        height: "100vh",
        margin: "0",
        padding: "0",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        fontFamily: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif",
        zIndex: "2147483647",
        pointerEvents: "auto" // Ensure it captures all clicks
    });
    
    // Add backdrop to overlay first
    overlay.appendChild(backdrop);
    // Then add content on top
    overlay.appendChild(content);
    
    // Force body and html styles to ensure full coverage
    const originalBodyOverflow = document.body.style.overflow;
    const originalHtmlOverflow = document.documentElement.style.overflow;
    const originalBodyHeight = document.body.style.height;
    const originalHtmlHeight = document.documentElement.style.height;
    
    // Apply styles to prevent scrolling and ensure full height
    document.body.style.overflow = 'hidden';
    document.documentElement.style.overflow = 'hidden';
    document.body.style.height = '100vh';
    document.documentElement.style.height = '100vh';
    
    // Insert overlay as the very last element in body
    document.body.appendChild(overlay);
    
    // Cleanup function
    const cleanup = () => {
        document.body.style.overflow = originalBodyOverflow;
        document.documentElement.style.overflow = originalHtmlOverflow;
        document.body.style.height = originalBodyHeight;
        document.documentElement.style.height = originalHtmlHeight;
    };
    
    // Store cleanup function on overlay for external access
    overlay._cleanup = cleanup;
    
    // Prevent any clicks from going through to the page behind
    overlay.addEventListener('click', (e) => {
        e.stopPropagation();
    });
    
    return overlay; // Return overlay reference for external control
}

// Helper function to get highest z-index
function getHighestZIndex() {
    const elements = document.querySelectorAll('*');
    let highest = 0;
    
    elements.forEach(el => {
        const zIndex = parseInt(window.getComputedStyle(el).zIndex) || 0;
        if (zIndex > highest) highest = zIndex;
    });
    
    return highest;
}

// Helper functions for managing unshielded websites
function getUnshieldedWebsites() {
    const stored = localStorage.getItem('7iii-unshielded-websites');
    return stored ? JSON.parse(stored) : {};
}

function addUnshieldedWebsite(website, minutes) {
    const unshielded = getUnshieldedWebsites();
    const endDate = new Date(Date.now() + (minutes * 60 * 1000));
    unshielded[website] = endDate.toISOString();
    localStorage.setItem('7iii-unshielded-websites', JSON.stringify(unshielded));
}

function isWebsiteUnshielded(website) {
    const unshielded = getUnshieldedWebsites();
    if (!unshielded[website]) return false;
    
    const endDate = new Date(unshielded[website]);
    const now = new Date();
    
    if (now > endDate) {
        // Time expired, remove from unshielded
        delete unshielded[website];
        localStorage.setItem('7iii-unshielded-websites', JSON.stringify(unshielded));
        return false;
    }
    
    return true;
}

function removeWebsite(topUpMinutes) {
    browser.runtime.sendMessage({ action: "remove-top-up"});
    
    // Add the current website to unshielded list with expiration time
    const currentDomain = window.location.hostname.replace(/^www\./, '');
    addUnshieldedWebsite(currentDomain, topUpMinutes);
    
    // Remove the website shield overlay
    const existingOverlay = document.getElementById('7iii-life-overlay');
    if (existingOverlay) {
        if (existingOverlay._cleanup) {
            existingOverlay._cleanup();
        }
        existingOverlay.remove();
    }
}

function isCurrentSiteBlocked(blockedWebsites) {
    const currentDomain = window.location.hostname.replace(/^www\./, '');
    
    // First check if the website is temporarily unshielded
    if (isWebsiteUnshielded(currentDomain)) {
        return false;
    }
    
    // Check against blocked websites list
    return blockedWebsites.some(website => {
        // Remove protocol and www from blocked website
        const cleanWebsite = website.replace(/^https?:\/\/(www\.)?/, '');
        
        // Check for exact match or if current domain ends with the blocked domain
        const isBlocked = currentDomain === cleanWebsite ||
                         currentDomain.endsWith('.' + cleanWebsite) ||
                         cleanWebsite.endsWith('.' + currentDomain);
        
        // If blocked, also check if it's unshielded
        if (isBlocked && isWebsiteUnshielded(cleanWebsite)) {
            return false;
        }
        
        return isBlocked;
    });
}

// Check blocked websites status
async function checkBlockedStatus() {
    try {
        const response = await browser.runtime.sendMessage({ action: "getBlockedWebsites" });
        console.log("Received response: ", response);
        
        if (response && response.websites) {
            const isBlocked = isCurrentSiteBlocked(response.websites);
            const overlayExists = document.getElementById('7iii-life-overlay');
            
            if (isBlocked) {
                // Site is blocked but no overlay shown - show it
                showWebsiteShield(response.websites, response.topUpActive, response.topUpMinutes);
            } else if (!isBlocked && overlayExists) {
                // Site is no longer blocked but overlay is shown - remove it
                if (overlayExists._cleanup) {
                    overlayExists._cleanup();
                }
                overlayExists.remove();
            }
        } else if (response && response.error) {
            console.error("Error getting blocked websites:", response.error);
        }
    } catch (error) {
        console.error("Error checking blocked status:", error);
    }
}

// Initial check
checkBlockedStatus();

// Set up periodic checking every 6 seconds
const statusCheckInterval = setInterval(checkBlockedStatus, 6000);

// Clean up interval when page is about to unload
window.addEventListener('beforeunload', () => {
    clearInterval(statusCheckInterval);
});
