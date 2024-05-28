# OpenMR project website

## Scope

- Static site
- Search / browse MR methods
- Form to contribute new methods
- Visualisation of methods
- About page
- Simulation results

## Developers

This is a static site generated using [Quarto](https://quarto.org/docs/get-started/). This means that you can write pages and posts in RMarkdown and then render those files into html pages locally. Those html pages are then pushed to github and served by github pages.

1. Install [Quarto](https://quarto.org/docs/get-started/)
2. Install `renv` in R - `install.packages("renv")`
3. Create environment in R - `renv::restore()`
4. Make sure the data from the submission form is stored in `data/mrmn.xlsx`
5. Render the site on command line - `quarto render`
6. Preview the site on command line - `quarto preview`

### Processing the data in the submission form

Once you download the submission form in xlsx format to `/data/mrmn.xlsx`, two things need to happen:

- Organise / format the data
- Generate a page in the `entries` directory for every method

This is achieved with the `generate.r` script. Whenever `quarto render` is run, it will run `generate.r` as a pre-rendering step automatically, so you should only have to do anything with that file if you want to edit it.

It generates posts by converting the data into yaml format for each method, and then adding that to the front matter for the `data/template` file.

### Add a new page

- create `/newpage.qmd`, include metadata (e.g. copy from one of the other `/page.qmd`) files
- Run `quarto render`

### Add new blog post

- create `/posts/<new_page_name>/index.qmd`
- Run `quarto render`

### Publishing

Once you've previewed the changes and are happy, push them to github.

Note: *do not allow any unnecessary files to exist in the directory*

```bash
git add *
git commit -a -m "<insert message>"
git push
```

### Updating the mr_lit publications per week

1. Go to https://pubmed.ncbi.nlm.nih.gov
2. Search for `"Mendelian randomisation" [Title] OR "Mendelian randomization" [Title]`
3. Click `Save`
4. Selection: `All results`
5. Format: `CSV`
6. Click `Create file`
7. Move that saved file `csv-Mendelianr-set.csv` to the `/data` directory (replacing the previous version)
8. Regenerate quarto site (`quarto render`)

## Notes

### Comments

- Each post has a comments section enabled by <https://utteranc.es>

### Data tables

- Using <https://rstudio.github.io/DT/> to display list of methods
- Can also generate a post for every method. Potentially offer two different views of the data

### Forms

- Currently using Microsoft Forms
- Need to manually download the Excel spreadsheet and use generate.r to convert for use on website
- Potential to embed on static site

Alternative approaches

- <https://github.com/json-editor/json-editor> - this allows creation of forms from json schema, need to figure out if it can be used on static website, e.g. <https://observablehq.com/@a10k/hello-json-editor>
- <https://www.staticforms.xyz> - emails form
- <https://jsonforms.io/> - richer schemas defined by json including rules - need to figure out if it can be used on a static website
- Quarto has forms extension <https://github.com/jlgraves-ubc/forms>
