<p align="center">
  <img src="https://api.octoperf.com/doc/monitoring/create-connection/microsoft-iis/img/iis-logo.png" alt="ISAPI Web Server Architecture" width="100%" />
</p>

# Delphi ISAPI Extension & Web Server Application

A lightweight, custom ISAPI (Internet Server Application Programming Interface) extension template and handler written in Delphi (Object Pascal). This project provides a robust foundation for building high-performance web applications, handling HTTP requests, inspecting Extension Control Blocks (ECB), and managing server variables on Microsoft Internet Information Services (IIS).

## ✨ Features

* **ISAPI Entry Points**: Implements standard ISAPI exported functions (`GetExtensionVersion`, `HttpExtensionProc`, and `TerminateExtension`).

* **Request & Response Wrapper**: Utilizes custom wrapper units (`TISAPIRequest` and `TISAPIResponse`) for structured handling.

* **Environment & Server Diagnostics**: Automatically inspects and dumps server variables, command line arguments, and ECB metadata for debugging.

* **Multithreading Support**: Configured with `COINIT_MULTITHREADED` for optimal thread safety under IIS.

* **Custom HTML Output**: Easily extensible template renderer for serving dynamic content and handling multipart forms.

## 🛠️ Project Structure

* **`cisapi.dpr`** (Main Entry / Provided Code): Core DLL source file handling module lifecycle, request routing, and exception boundaries.

* **`HTTPAppModify.pas`**: Custom modifications/extensions for web application handling.

* **`Isapi2.pas`**: Core ISAPI definitions and structures.

* **`IsapiReqRes.pas`**: Request and Response abstraction layers.

* **`hmls.pas`**: HTML generation or layout helper unit.

## 🚀 Getting Started

### Prerequisites

* Delphi (compatible version supporting ISAPI/VCL web services).

* Microsoft IIS (Internet Information Services) installed on Windows with ISAPI Extension support enabled.

### Compilation & Installation

1. Clone or download this repository.

2. Open the project group or `cisapi.dpr` in your Delphi IDE.

3. Build the project to generate the ISAPI DLL file (e.g., `cisapi.dll`).

4. Place the compiled DLL and its dependencies into an IIS virtual directory configured with **Execute Permissions** (Scripts and Executables).

5. Point your browser to the DLL endpoint (e.g., `http://localhost/YourVirtualDir/cisapi.dll`).

## 💡 Repository Description Suggestions (for GitHub)

Choose one of the following short descriptions for your GitHub repository header:

* **Option 1 (Concise):** `A custom ISAPI extension template and HTTP request handler written in Delphi for Microsoft IIS.`

* **Option 2 (Technical):** `Delphi-based ISAPI DLL module featuring request parsing, server variable inspection, and multithreading support.`

* **Option 3 (Action-oriented):** `Lightweight Delphi ISAPI framework for building high-performance web applications and extensions on IIS.`

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page.

## 📝 License

This project is open-source and available under the [MIT License](LICENSE).