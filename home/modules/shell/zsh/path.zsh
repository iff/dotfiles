path=(
    # FIXME remove and use direnv in projects
    $HOME/bin/nodejs/bin
    $HOME/.cargo/bin
    $path
)

# path -> reverse -> keep only first unique -> reverse
# prevents any duplication for paths that are already setup
path=(${(Oa)${(u)${(Oa)path}}})
export path PATH
