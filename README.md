# scanarium-shell-injector

`scanarium-shell-injector` allows to upload files for scanning in Scanarium right from your console.

## Installation

1. Install curl. (On Ubuntu-like systems, run `sudo apt-get install curl`)
2. Add your username/password to your `~/.netrc` by adding a line like (obviously replacing
`YOUR-SCANARIUM-USERNAME` by your username and `YOUR-SCANARIUM-PASSWORD` by your password):

```
machine YOUR-SCANARIUM-USERNAME.scanarium.com login YOUR-SCANARIUM-USERNAME password YOUR-SCANARIUM-PASSWORD
```

3. Done \o/

## Usage

To upload the file `foo.jpg` to your Scanarium, run (replacing `/path/to` with the path to the script, and `YOUR-SCANARIUM-USERNAME` with your scanarium username):

```
/path/to/inject.sh --user YOUR-SCANARIUM-USERNAME foo.jpg
```

If the username that you use on your computer matches your Scanarium username, you can leave the `--user YOUR-SCANARIUM-USERNAME` part away and a simple `/path/to/inject.sh foo.jpg` will do.

Passing the argument `--help` to the script will show all available arguments.

## Feedback / Issues

Please use [GitHub's issue tracker](https://github.com/scanarium/scanarium-shell-injector/issues/new) to report feedback or issues.

