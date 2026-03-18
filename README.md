# Vedan - Bug Bounty Toolkit 🛠️

Vedan is a powerful and automated Bug Bounty Toolkit designed to simplify subdomain enumeration, HTTP probing, and XSS vulnerability scanning. It is built with simplicity and efficiency in mind, making it a great tool for bug bounty hunters, security researchers, and developers.

---

## Features ✨
- **Subdomain Enumeration**: Uses `subfinder` and `amass` to discover subdomains.
- **HTTP Probing**: Uses `httprobe` to find live HTTP/HTTPS servers.
- **XSS Scanning**: Uses `waybackurls` and `kxss` to identify potential XSS vulnerabilities.
- **Automated Workflow**: Combines multiple tools into a single, easy-to-use script.
- **Output Organization**: Saves all results in a dedicated `~/vedan/` directory.

---

## Environment 
 - **This Tool is tested only in Kali and Parrot**

 
## Installation 🛠️

### Prerequisites
Before using Vedan, ensure you have the following installed:
- **Go** (to install Go-based tools)
- **Git** (to clone the repository)

### Step 1: Clone the Repository
```bash
git clone https://github.com/devkumar-swipe/vedan.git
```

### Step 2: Make the Script Executable
```bash
chmod +x vedan.sh
```
## Options
-d, --domain: Specify the target domain (e.g., example.com).

-h, --help: Display the help menu.

Usage 🚀
Basic Usage
Run the script with a target domain:
```bash
./vedan.sh -d example.com
```
**It will automatically download all dependencies which are required and executed.**
![image](https://github.com/user-attachments/assets/1301b22f-ec76-4a06-b7b0-98278efd492a)

### Output 📂
All output files are saved in the ~/vedan/ directory. Here’s an example of the files generated:

~/vedan/
├── domains_subfinder_example.com.txt
├── domains_example.com.txt
├── domains_example.com_resolved.txt
├── xss_example.com.txt
└── bug_bounty_tool.log

### Dependencies 📦
The following tools are required for Vedan to work:
subfinder
amass
httprobe
waybackurls
kxss
filter-resolved
Refer to the requirements.txt file for more details.

### Support and Contact 📧
If you have any questions, suggestions, or need support, feel free to reach out:
For collaboration feel free to contact.

Email:v2284985@gmail.com

### License 📄
This project is licensed under the MIT License. See the LICENSE file for details.

### Acknowledgments 🙏
Thanks to the creators of subfinder, amass, httprobe, waybackurls, and kxss for their amazing tools.

Special thanks to the bug bounty community for their support and inspiration.

Happy Hunting! 🐛🔍
