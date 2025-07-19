 (function() {
     'use strict';
     
     let isBlocked = false;
     let blockOverlay = null;
     let checkInterval = null;
     let currentStatus = null;
     
     // Configuration
     const CHECK_INTERVAL = 1000; // Check every second
     const APP_GROUP_KEY = 'group.com.project7iii.life';
     
     // Initialize the extension
     function init() {
         // Start checking for blocked websites
         checkInterval = setInterval(checkBlockStatus, CHECK_INTERVAL);
         checkBlockStatus(); // Initial check
     }
     
     // Check if current website should be blocked
     async function checkBlockStatus() {
         try {
             const currentDomain = extractDomain(window.location.href);
             
             // Get data from background script
             const response = await browser.runtime.sendMessage({
                 type: 'getBlockingStatus',
                 domain: currentDomain
             });
             
             if (response) {
                 currentStatus = response;
                 
                 if (response.shouldBlock) {
                     if (response.isUnshielded) {
                         // Website is temporarily unshielded, show normal content
                         removeBlocking();
                     } else if (response.topUpActive) {
                         // Show shield with top-up option
                         showShieldWithTopUp(response.topUpMinutes);
                     } else {
                         // Show basic shield (no top-up available)
                         showBasicShield();
                     }
                 } else {
                     // Website not blocked, show normal content
                     removeBlocking();
                 }
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
             return hostname.replace(/^www\./, '');
         } catch (error) {
             return '';
         }
     }
     
     // Show basic shield without top-up option
     function showBasicShield() {
         if (isBlocked) return;
         
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
     }
     
     // Show shield with top-up option
     function showShieldWithTopUp(minutes) {
         if (isBlocked) return;
         
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
         }
         
         // Hide the original page content
         document.documentElement.style.overflow = 'hidden';
     }
     
     // Handle top-up button click
     function handleTopUp() {
         // Disable button to prevent double-clicks
         const topUpBtn = document.querySelector('#life-shield-topup-btn');
         if (topUpBtn) {
             topUpBtn.disabled = true;
             topUpBtn.textContent = '⏳ Processing...';
         }
         
         // Send message to background script to add website to unshielded list
         browser.runtime.sendMessage({
             type: 'requestTopUp',
             domain: extractDomain(window.location.href)
         });
     }
     
     // Remove all blocking elements
     function removeBlocking() {
         if (blockOverlay) {
             blockOverlay.remove();
             blockOverlay = null;
         }
         
         // Restore page scrolling
         document.documentElement.style.overflow = '';
         isBlocked = false;
     }
     
     // Listen for messages from background script
     browser.runtime.onMessage.addListener((message, sender, sendResponse) => {
         switch (message.type) {
             case 'statusUpdate':
                 // Force immediate check when status updates
                 checkBlockStatus();
                 break;
             case 'topUpResponse':
                 if (message.success) {
                     // Top-up successful, remove shield and show confirmation
                     removeBlocking();
                     showTopUpConfirmation(message.duration || currentStatus?.topUpMinutes || 1);
                 } else {
                     // Top-up failed, re-enable button
                     const topUpBtn = document.querySelector('#life-shield-topup-btn');
                     if (topUpBtn) {
                         topUpBtn.disabled = false;
                         topUpBtn.textContent = `⏰ Unblock for ${currentStatus?.topUpMinutes || 1} minute${(currentStatus?.topUpMinutes || 1) !== 1 ? 's' : ''}`;
                     }
                 }
                 break;
         }
     });
     
     // Show confirmation after successful top-up
     function showTopUpConfirmation(minutes) {
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
         
         // Remove after 4 seconds
         setTimeout(() => {
             if (confirmation && confirmation.parentNode) {
                 confirmation.remove();
             }
         }, 4000);
     }
     
     // Cleanup when page unloads
     window.addEventListener('beforeunload', () => {
         if (checkInterval) {
             clearInterval(checkInterval);
         }
     });
     
     // Initialize when DOM is ready
     if (document.readyState === 'loading') {
         document.addEventListener('DOMContentLoaded', init);
     } else {
         init();
     }
 })();
