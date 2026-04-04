# Homebrew Tap

This repository is a custom Homebrew tap `zerospiel/tools`.

## Repository Layout

- `Formula/`: Homebrew formulae
- `Casks/`: Homebrew casks
- `.github/workflows/validate-tap.yml`: validation workflow for PRs, pushes, and manual runs
- `.github/workflows/monthly-livecheck.yml`: manual update-check workflow

## Add a new Formula

Create `Formula/<name>.rb`.

Minimal example:

```ruby
class MyCli < Formula
  desc "Short description"
  homepage "https://github.com/<owner>/<repo>"
  url "https://github.com/<owner>/<repo>/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "<SHA256_OF_TARBALL>"
  license "MIT"

  def install
    bin.install "mycli"
  end

  test do
    system "#{bin}/mycli", "--help"
  end
end
```

Validation locally from this repository checkout:

```bash
brew tap zerospiel/tools "$(pwd)"
brew readall --syntax --eval-all zerospiel/tools
brew audit --strict --online zerospiel/tools/<name>
brew fetch --retry --force --formula zerospiel/tools/<name>
brew install --build-from-source zerospiel/tools/<name>
brew test zerospiel/tools/<name>
```

To update an existing formula, edit `Formula/<name>.rb` and run the same validation steps.

## Add a new Cask

Create `Casks/<name>.rb`.

Minimal example:

```ruby
cask "my-app" do
  version "0.1.0"
  sha256 "<SHA256_OF_ARTIFACT>"

  url "https://github.com/<owner>/<repo>/releases/download/v#{version}/MyApp.zip"
  name "My App"
  desc "Short description"
  homepage "https://github.com/<owner>/<repo>"

  app "MyApp.app"
end
```

Validation locally from this repository checkout:

```bash
brew tap zerospiel/tools "$(pwd)"
brew readall --syntax --eval-all zerospiel/tools
brew audit --strict --online --cask zerospiel/tools/<name>
brew fetch --retry --force --cask zerospiel/tools/<name>
brew install --cask zerospiel/tools/<name>
```

To update an existing cask, edit `Casks/<name>.rb` and run the same validation steps.

## Install from this tap

Tap this repository:

```bash
brew tap zerospiel/tools
```

Equivalent explicit URL form:

```bash
brew tap zerospiel/tools https://github.com/zerospiel/homebrew-tools.git
```

Install a formula from this tap:

```bash
brew install zerospiel/tools/<formula_name>
```

Install a cask from this tap:

```bash
brew install --cask zerospiel/tools/<cask_name>
```

Upgrade and uninstall:

```bash
brew update
brew upgrade zerospiel/tools/<formula_name>
brew uninstall zerospiel/tools/<formula_name>
```

## Automation (GitHub Actions)

This tap has two workflows:

- `.github/workflows/validate-tap.yml`
  - Triggers on PR/push for `Formula/**` and `Casks/**`, plus manual dispatch
  - Uses workflow concurrency to cancel superseded in-progress runs on the same ref
  - Uses four jobs: `changes`, `syntax`, `formulae`, and `casks`
  - Runs `brew readall --syntax --eval-all` in the syntax job
  - Runs strict online audits in dedicated formula/cask jobs for changed files on PR/push, or all entries on manual dispatch
  - Runs `brew fetch --retry --force` for formulae/casks being validated to verify URL reachability and SHA256 checks
  - Builds changed formulae from source and runs `brew test` after audit/fetch

- `.github/workflows/monthly-livecheck.yml`
  - Manual trigger only (`workflow_dispatch`)
  - Fetches all formulae/casks (URL + checksum validation)
  - Runs `brew livecheck --json` for each entry
  - Builds a report and posts/updates an issue when updates or fetch failures are detected

To run monthly check manually:

1. Open GitHub Actions in this repository.
1. Select `Monthly Tap Update Check`.
1. Click `Run workflow`.
