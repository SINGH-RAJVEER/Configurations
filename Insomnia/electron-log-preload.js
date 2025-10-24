
      try {
        (function initialize({ contextBridge, ipcRenderer }) {
      if (!ipcRenderer) {
        return;
      }
      ipcRenderer.on("__ELECTRON_LOG_IPC__", (_2, message2) => {
        window.postMessage({ cmd: "message", ...message2 });
      });
      ipcRenderer.invoke("__ELECTRON_LOG__", { cmd: "getOptions" }).catch((e2) => console.error(new Error(
        `electron-log isn't initialized in the main process. Please call log.initialize() before. ${e2.message}`
      )));
      const electronLog = {
        sendToMain(message2) {
          try {
            ipcRenderer.send("__ELECTRON_LOG__", message2);
          } catch (e2) {
            console.error("electronLog.sendToMain ", e2, "data:", message2);
            ipcRenderer.send("__ELECTRON_LOG__", {
              cmd: "errorHandler",
              error: { message: e2?.message, stack: e2?.stack },
              errorName: "sendToMain"
            });
          }
        },
        log(...data2) {
          electronLog.sendToMain({ data: data2, level: "info" });
        }
      };
      for (const level of ["error", "warn", "info", "verbose", "debug", "silly"]) {
        electronLog[level] = (...data2) => electronLog.sendToMain({
          data: data2,
          level
        });
      }
      if (contextBridge && process.contextIsolated) {
        try {
          contextBridge.exposeInMainWorld("__electronLog", electronLog);
        } catch {
        }
      }
      if (typeof window === "object") {
        window.__electronLog = electronLog;
      } else {
        __electronLog = electronLog;
      }
    })(require('electron'));
      } catch(e) {
        console.error(e);
      }
    