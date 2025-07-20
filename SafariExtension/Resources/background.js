browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    
    if (request.action === "getBlockedWebsites") {
        // Forward request to native app via Safari extension handler
        browser.runtime.sendNativeMessage("application.id", { action: "getBlockedWebsites" })
            .then(response => {
                sendResponse(response);
            })
            .catch(error => {
                console.error("Error getting blocked websites:", error);
                sendResponse({ error: "Failed to get blocked websites" });
            });
        
        return true; // Indicates we will call sendResponse asynchronously
        
    } else if (request.action === "close-tab" && sender.tab?.id) {
        browser.tabs.remove(sender.tab.id);
    } else if (request.action === "remove-top-up") {
        // Forward request to native app via Safari extension handler
        browser.runtime.sendNativeMessage("application.id", { action: "remove-top-up" });
    }
});
