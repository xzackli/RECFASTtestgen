# RECFASTtestgen
pirated fortran recfast for generating bolt tests. taken straight from Cosmology.jl

### instructions for future zack
```
cd deps
julia -e 'using Pkg; Pkg.add("BinDeps")'
julia build.jl
```

Then in root directory
```
julia gentest.jl
```
