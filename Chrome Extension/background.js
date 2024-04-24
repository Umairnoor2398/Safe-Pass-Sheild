chrome.runtime.onMessage.addListener(function (request, sender, sendResponse) {
  if (request.action === "get_data") {
    // Do something and send response
    sendResponse({ data: "Some data from background" });
  }
});
