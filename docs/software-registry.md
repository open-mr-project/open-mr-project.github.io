# Software registry

## Submission

Please submit your method on the [submission](submission.md) page.

## Binary R packages from MRCIEU r-universe

We maintain <https://mrcieu.r-universe.dev> which distributes binary versions of R packages for several operating systems (Windows, macOS with Intel processors, and Ubuntu Linux Jammy). This includes alot of MR related R packages. Do let us know if you would like us to add a package.

To install binary R packages from the MRCIEU r-universe, include this in your `repos`list as follows, e.g., to install the **TwoSampleMR** package
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
