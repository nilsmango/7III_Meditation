
function showWebsitesList(websites, topUpActive, topUpMinutes) {
    const overlay = document.createElement("div");
    
    // Top-up status section
    if (topUpActive !== undefined && topUpMinutes !== undefined) {
        const topUpStatus = document.createElement("div");
        topUpStatus.style.marginBottom = "12px";
        topUpStatus.style.paddingBottom = "8px";
        topUpStatus.style.borderBottom = "1px solid #444";
        
        const statusText = document.createElement("div");
        statusText.style.fontWeight = "bold";
        statusText.style.marginBottom = "4px";
        
        if (topUpActive) {
            statusText.textContent = "⏰ Top-up Active";
            statusText.style.color = "#4CAF50"; // Green
            
            const minutesText = document.createElement("div");
            minutesText.textContent = `${topUpMinutes} minutes remaining`;
            minutesText.style.color = "#FFF";
            minutesText.style.fontSize = "11px";
            
            topUpStatus.appendChild(statusText);
            topUpStatus.appendChild(minutesText);
        } else {
            statusText.textContent = "⏸️ No Active Top-up";
            statusText.style.color = "#FF9800"; // Orange
            topUpStatus.appendChild(statusText);
        }
        
        overlay.appendChild(topUpStatus);
    }
    
    // Blocked websites section
    const title = document.createElement("div");
    title.textContent = "Blocked Websites:";
    title.style.fontWeight = "bold";
    title.style.marginBottom = "8px";
    
    if (websites.length === 0) {
        const noWebsites = document.createElement("div");
        noWebsites.textContent = "No blocked websites found";
        noWebsites.style.fontStyle = "italic";
        noWebsites.style.color = "#ccc";
        overlay.appendChild(title);
        overlay.appendChild(noWebsites);
    } else {
        const list = document.createElement("ul");
        list.style.margin = "0";
        list.style.paddingLeft = "16px";
        
        websites.forEach(website => {
            const listItem = document.createElement("li");
            const link = document.createElement("a");
            link.href = website.startsWith('http') ? website : 'https://' + website;
            link.textContent = website.replace(/^https?:\/\/(www\.)?/, '');
            link.target = "_blank";
            link.style.color = "#FF6B6B";
            link.style.textDecoration = "none";
            listItem.appendChild(link);
            list.appendChild(listItem);
        });
        
        overlay.appendChild(title);
        overlay.appendChild(list);
    }
    
    Object.assign(overlay.style, {
        position: "fixed",
        top: "10px",
        right: "10px",
        background: "rgba(0,0,0,0.9)",
        color: "white",
        padding: "12px 16px",
        borderRadius: "8px",
        zIndex: 9999,
        fontSize: "12px",
        maxWidth: "250px",
        maxHeight: "350px", // Increased to accommodate top-up info
        overflowY: "auto"
    });
    
    document.body.appendChild(overlay);
    setTimeout(() => overlay.remove(), 4000); // Increased to 4s for more content
}

// Request blocked websites
browser.runtime.sendMessage({ action: "getBlockedWebsites" }).then((response) => {
    console.log("Received response: ", response);
    if (response && response.websites) {
        showWebsitesList(response.websites, response.topUpActive, response.topUpMinutes);
    } else if (response && response.error) {
        showOverlay("Error: " + response.error);
    }
});
