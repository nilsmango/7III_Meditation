(function() {
    'use strict';
    
    console.log('Life Shield: Content script starting...');
    
    let isBlocked = false;
    let blockOverlay = null;
    let checkInterval = null;
    let currentStatus = null;
    
    // Configuration
    const CHECK_INTERVAL = 1000; // Check every second
    const APP_GROUP_KEY = 'group.com.project7iii.life';
    
    // Initialize the extension
    function init() {
        console.log('Life Shield: Content script initializing...');
        console.log('Life Shield: Current URL:', window.location.href);
        console.log('Life Shield: Current domain:', extractDomain(window.location.href));
        
        // Add CSS styles
        addStyles();
        
        // Start checking for blocked websites
        checkInterval = setInterval(checkBlockStatus, CHECK_INTERVAL);
        checkBlockStatus(); // Initial check
    }
    
    // Add CSS styles for the blocking overlay
    function addStyles() {
        const style = document.createElement('style');
        style.textContent = `
            #life-shield-block-overlay {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                z-index: 2147483647;
                display: flex;
                align-items: center;
                justify-content: center;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            }
            
            .life-shield-content {
                text-align: center;
                color: white;
                max-width: 400px;
                padding: 40px 30px;
                border-radius: 16px;
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            }
            
            .life-shield-icon {
                font-size: 64px;
                margin-bottom: 20px;
            }
            
            .life-shield-content h1 {
                margin: 0 0 20px 0;
                font-size: 28px;
                font-weight: 700;
            }
            
            .life-shield-content p {
                margin: 0 0 15px 0;
                font-size: 16px;
                line-height: 1.5;
                opacity: 0.9;
            }
            
            .life-shield-domain {
                background: rgba(0, 0, 0, 0.3);
                padding: 8px 16px;
                border-radius: 20px;
                font-family: monospace;
                font-size: 14px;
                margin: 20px 0;
                word-break: break-all;
            }
            
            .life-shield-topup-btn {
                background: #4CAF50;
                color: white;
                border: none;
                padding: 12px 24px;
                border-radius: 25px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                margin-top: 20px;
                transition: all 0.3s ease;
                min-width: 200px;
            }
            
            .life-shield-topup-btn:hover {
                background: #45a049;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
            }
            
            .life-shield-topup-btn:disabled {
                background: #666;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
            }
            
            #life-shield-confirmation {
                position: fixed;
                top: 20px;
                right: 20px;
                z-index: 2147483647;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            }
            
            .life-shield-confirmation-content {
                background: #4CAF50;
                color: white;
                padding: 16px 24px;
                border-radius: 8px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
                display: flex;
                align-items: center;
                gap: 12px;
                animation: slideIn 0.3s ease;
            }
            
            .life-shield-confirmation-icon {
                font-size: 20px;
            }
            
            .life-shield-confirmation-text {
                font-weight: 500;
            }
            
            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
        `;
        document.head.appendChild(style);
    }
    
    // Check if current website should be blocked
    async function checkBlockStatus() {
        try {
            const currentDomain = extractDomain(window.location.href);
            console.log('Life Shield: Checking block status for:', currentDomain);
            
            // Get data from background script
            const response = await browser.runtime.sendMessage({
                type: 'getBlockingStatus',
                domain: currentDomain
            });
            
            console.log('Life Shield: Received response:', response);
            
            if (response) {
                currentStatus = response;
                
                if (response.shouldBlock) {
                    console.log('Life Shield: Website should be blocked');
                    if (response.isUnshielded) {
                        console.log('Life Shield: Website is unshielded, remaining time:', response.remainingTime);
                        // Website is temporarily unshielded, show normal content
                        removeBlocking();
                    } else if (response.topUpActive) {
                        console.log('Life Shield: Top-up is active, showing shield with top-up option');
                        // Show shield with top-up option
                        showShieldWithTopUp(response.topUpMinutes);
                    } else {
                        console.log('Life Shield: Top-up not active, showing basic shield');
                        // Show basic shield (no top-up available)
                        showBasicShield();
                    }
                } else {
                    console.log('Life Shield: Website not blocked, showing normal content');
                    // Website not blocked, show normal content
                    removeBlocking();
                }
            } else {
                console.log('Life Shield: No response received from background script');
            }
        } catch (error) {
            console.log('Life Shield: Error checking block status:', error);
        }
    }
    
    // Extract domain from URL
    function extractDomain(url) {
        try {
            const hostname = new URL(url).hostname;
            // Remove www. prefix if present
            const domain = hostname.replace(/^www\./, '');
            console.log('Life Shield: Extracted domain:', domain, 'from URL:', url);
            return domain;
        } catch (error) {
            console.log('Life Shield: Error extracting domain from URL:', url, error);
            return '';
        }
    }
    
    // Show basic shield without top-up option
    function showBasicShield() {
        if (isBlocked) {
            console.log('Life Shield: Basic shield already showing');
            return;
        }
        
        console.log('Life Shield: Showing basic shield');
        isBlocked = true;
        
        // Create blocking overlay
        blockOverlay = document.createElement('div');
        blockOverlay.id = 'life-shield-block-overlay';
        blockOverlay.innerHTML = `
            <div class="life-shield-content">
                <div class="life-shield-icon">🛡️</div>
                <h1>Website Blocked</h1>
                <p>This website is currently blocked by Life Shield.</p>
                <p>Open the Life app to manage your blocked websites.</p>
                <div class="life-shield-domain">${extractDomain(window.location.href)}</div>
            </div>
        `;
        
        document.body.appendChild(blockOverlay);
        
        // Hide the original page content
        document.documentElement.style.overflow = 'hidden';
        console.log('Life Shield: Basic shield displayed');
    }
    
    // Show shield with top-up option
    function showShieldWithTopUp(minutes) {
        if (isBlocked) {
            console.log('Life Shield: Shield with top-up already showing');
            return;
        }
        
        console.log('Life Shield: Showing shield with top-up option for', minutes, 'minutes');
        isBlocked = true;
        
        // Create blocking overlay with top-up button
        blockOverlay = document.createElement('div');
        blockOverlay.id = 'life-shield-block-overlay';
        blockOverlay.innerHTML = `
            <div class="life-shield-content">
                <div class="life-shield-icon">🛡️</div>
                <h1>Website Blocked</h1>
                <p>This website is currently blocked by Life Shield.</p>
                <p>You can temporarily unblock it for ${minutes} minute${minutes !== 1 ? 's' : ''}.</p>
                <div class="life-shield-domain">${extractDomain(window.location.href)}</div>
                <button class="life-shield-topup-btn" id="life-shield-topup-btn">
                    ⏰ Unblock for ${minutes} minute${minutes !== 1 ? 's' : ''}
                </button>
            </div>
        `;
        
        document.body.appendChild(blockOverlay);
        
        // Add click handler for top-up button
        const topUpBtn = blockOverlay.querySelector('#life-shield-topup-btn');
        if (topUpBtn) {
            topUpBtn.addEventListener('click', handleTopUp);
            console.log('Life Shield: Top-up button click handler added');
        }
        
        // Hide the original page content
        document.documentElement.style.overflow = 'hidden';
        console.log('Life Shield: Shield with top-up displayed');
    }
    
    // Handle top-up button click
    function handleTopUp() {
        console.log('Life Shield: Top-up button clicked');
        
        // Disable button to prevent double-clicks
        const topUpBtn = document.querySelector('#life-shield-topup-btn');
        if (topUpBtn) {
            topUpBtn.disabled = true;
            topUpBtn.textContent = '⏳ Processing...';
            console.log('Life Shield: Top-up button disabled');
        }
        
        // Send message to background script to add website to unshielded list
        const domain = extractDomain(window.location.href);
        console.log('Life Shield: Requesting top-up for domain:', domain);
        
        browser.runtime.sendMessage({
            type: 'requestTopUp',
            domain: domain
        }).then((response) => {
            console.log('Life Shield: Top-up request sent successfully, response:', response);
        }).catch((error) => {
            console.log('Life Shield: Error sending top-up request:', error);
            
            // Re-enable button on error
            if (topUpBtn) {
                topUpBtn.disabled = false;
                topUpBtn.textContent = `⏰ Unblock for ${currentStatus?.topUpMinutes || 1} minute${(currentStatus?.topUpMinutes || 1) !== 1 ? 's' : ''}`;
            }
        });
    }
    
    // Remove all blocking elements
    function removeBlocking() {
        if (blockOverlay) {
            console.log('Life Shield: Removing blocking overlay');
            blockOverlay.remove();
            blockOverlay = null;
        }
        
        // Restore page scrolling
        document.documentElement.style.overflow = '';
        isBlocked = false;
        console.log('Life Shield: Blocking removed, page restored');
    }
    
    // Listen for messages from background script
    browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
        console.log('Life Shield: Content script received message:', message);
        
        switch (message.type) {
            case 'statusUpdate':
                console.log('Life Shield: Status update received, forcing check');
                // Force immediate check when status updates
                checkBlockStatus();
                break;
                
            case 'topUpResponse':
                console.log('Life Shield: Top-up response received:', message);
                if (message.success) {
                    console.log('Life Shield: Top-up successful');
                    // Top-up successful, remove shield and show confirmation
                    removeBlocking();
                    showTopUpConfirmation(message.duration || currentStatus?.topUpMinutes || 1);
                } else {
                    console.log('Life Shield: Top-up failed');
                    // Top-up failed, re-enable button
                    const topUpBtn = document.querySelector('#life-shield-topup-btn');
                    if (topUpBtn) {
                        topUpBtn.disabled = false;
                        topUpBtn.textContent = `⏰ Unblock for ${currentStatus?.topUpMinutes || 1} minute${(currentStatus?.topUpMinutes || 1) !== 1 ? 's' : ''}`;
                        console.log('Life Shield: Top-up button re-enabled');
                    }
                }
                break;
                
            default:
                console.log('Life Shield: Unknown message type:', message.type);
        }
    });
    
    // Show confirmation after successful top-up
    function showTopUpConfirmation(minutes) {
        console.log('Life Shield: Showing top-up confirmation for', minutes, 'minutes');
        
        const confirmation = document.createElement('div');
        confirmation.id = 'life-shield-confirmation';
        confirmation.innerHTML = `
            <div class="life-shield-confirmation-content">
                <div class="life-shield-confirmation-icon">✅</div>
                <div class="life-shield-confirmation-text">
                    Website unblocked for ${minutes} minute${minutes !== 1 ? 's' : ''}!
                </div>
            </div>
        `;
        
        document.body.appendChild(confirmation);
        console.log('Life Shield: Confirmation displayed');
        
        // Remove after 4 seconds
        setTimeout(() => {
            if (confirmation && confirmation.parentNode) {
                confirmation.remove();
                console.log('Life Shield: Confirmation removed');
            }
        }, 4000);
    }
    
    // Cleanup when page unloads
    window.addEventListener('beforeunload', () => {
        console.log('Life Shield: Page unloading, cleaning up');
        if (checkInterval) {
            clearInterval(checkInterval);
        }
    });
    
    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        console.log('Life Shield: DOM loading, waiting for DOMContentLoaded');
        document.addEventListener('DOMContentLoaded', init);
    } else {
        console.log('Life Shield: DOM ready, initializing immediately');
        init();
    }
    
    console.log('Life Shield: Content script setup complete');
})();
