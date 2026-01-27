John Ferri - Docs-as-Code Portfolio
This is a Docs-as-Code professional portfolio project, incorporating MkDocs, Markdown, a Git pull request (PR) workflow, and a page on GitHub Pages. While these examples explicitly mention government Security Operations Center (SOC) environments, the documentation workflow and standards in this repository also translate directly to internal product and security documentation efforts across the private sector. 



## Local preview (Windows)

~~~powershell
powershell -ExecutionPolicy Bypass -File .\scripts\serve_docs.ps1
~~~



## Local preview (WSL / Ubuntu)

~~~bash
cd /mnt/c/Users/"John Ferri"/projects/john-ferri-docs
bash scripts/serve_docs.sh
~~~

> Note: WSL uses a separate virtual environment folder (`.venv-wsl/`) to avoid conflicts with the Windows `.venv/`.
