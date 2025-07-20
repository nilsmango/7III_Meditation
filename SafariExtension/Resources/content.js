
function showWebsitesList(websites) {
    const overlay = document.createElement("div");
    
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
        maxHeight: "300px",
        overflowY: "auto"
    });
    
    document.body.appendChild(overlay);
    setTimeout(() => overlay.remove(), 3000); // auto-remove after 3s
}

// Request blocked websites
browser.runtime.sendMessage({ action: "getBlockedWebsites" }).then((response) => {
    console.log("Received blocked websites: ", response);
    if (response && response.websites) {
        showWebsitesList(response.websites);
    } else if (response && response.error) {
        showOverlay("Error: " + response.error);
    }
});
