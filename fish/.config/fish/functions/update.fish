
# Update all `mr` registered repositories
#
function update -d "Update all repos registered with mr"
  pushd $HOME
  mr up
  popd
end
