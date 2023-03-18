# Mendelian randomization Methods Network site

The website is built using mkdocs and mkdocs-material.

* Create a virtual environment for the project.

```bash
python3 -m venv venv
```

* Activate the virtual environment:

```bash
source venv/bin/activate
```

* Install the required dependencies:

```bash
python3 -m pip install -r requirements.txt
```

The site can then be edited as required.

* To serve a local build of the site use:

```bash
mkdocs serve
```

* The site is built on GitHub, everytime there is a commit onto the main branch, through a GitHub Actions workflow. The workflow commits the built site onto the `gh-pages` branch from where GitHub Pages serves it. Hence you don't really need to build the site locally (apart from checking that your edits are as indented with `mkdocs serve`) and therefore the `/site` directory is currently in the `.gitignore` file. If you need to build the site locally remove that entry from `.gitignore` and run:

```bash
mkdocs build
```

* To record the packages and their versions run

```bash
python3 -m pip freeze > requirements.txt
```
