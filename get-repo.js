function matchOwnerAndRepo(pattern, s) {
  const matchArray = s.match(pattern)
  if (matchArray && matchArray[0] && matchArray[1]) {
    return matchArray[1]
  }
}

function parseRepositoryInfo(repositoryInfo) {
  if (typeof repositoryInfo === "string") {
    const pattern = /^github:(.+)$/
    const match = matchOwnerAndRepo(pattern, repositoryInfo)
    if (match) return match
  }
  if (typeof repositoryInfo === "object" && "url" in repositoryInfo) {
    const pattern = /github.com\/(.+?)(\.git)?$/
    const match = matchOwnerAndRepo(pattern, repositoryInfo.url)
    if (match) return match
  }
  throw new Error(
    `Unexpected repository value in package.json: ${
      repositoryInfo.url || repositoryInfo
    }`
  )
}

try {
  const repositoryInfo = require("../../../package.json").repository
  process.stdout.write(parseRepositoryInfo(repositoryInfo))
} catch (e) {
  console.error(e)
  process.exit(1)
}
