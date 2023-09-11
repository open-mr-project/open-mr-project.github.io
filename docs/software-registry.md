# Software registry

## Submission

Please submit your method on the [submission](submission.md) page.

## Binary R packages from MRCIEU R-universe

We maintain the MRCIEU R-universe <https://mrcieu.r-universe.dev> which distributes binary R packages for several operating systems (Windows, macOS with Intel processors, and Ubuntu Linux Jammy). We have included alot of MR related R packages. Do let us know if you would like us to add a package.

### How to use the MRCIEU R-universe

To install binary R packages from the MRCIEU R-universe, include the URL in your `repos` list as follows, e.g., to install the **TwoSampleMR** package we could run in R
```r
install.packages('TwoSampleMR', repos = c('https://mrcieu.r-universe.dev', 'https://cloud.r-project.org'))
```
or
```r
options(repos = c('https://mrcieu.r-universe.dev', 'https://cloud.r-project.org'))
install.packages('TwoSampleMR')
```

## Benchmarking

### Simulations

### Empirical analysis
