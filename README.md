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

* To build the site

```bash
mkdocs build
```

* To record the packages and their versions run

```bash
python3 -m pip freeze > requirements.txt
```
