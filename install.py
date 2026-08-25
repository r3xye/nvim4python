#!/usr/bin/env python3
import shutil
import sys
import subprocess as sb 
from pathlib import Path

home = str(Path.home()) + "/"

class PackageManager():
    name: str

    def exists(self) -> bool:
        return shutil.which(self.name) is not None

    def run(self, command: list[str]) -> bool:
        result = sb.run(command)
        return result.returncode == 0

    def install(self, package: str) -> bool:
        raise NotImplementedError

    def is_installed(self, package: str) -> bool:
        raise NotImplementedError



class Pacman(PackageManager):
    name = "pacman"

    def install(self, package: str) -> bool:
        return self.run(["sudo", "pacman", "-S", "--noconfirm", "--needed", package])

    def is_installed(self, package: str) -> bool:
        return self.run(["pacman", "-Q", package])


class Xbps(PackageManager):
    name = "xbps-install"

    def install(self, package: str) -> bool:
        return self.run(["sudo", "xbps-install", "-Sy", package])

    def is_installed(self, package: str) -> bool:
        return self.run(["xbps-query", "-p", "pkgver", package])



def find_manager() -> PackageManager:
    managers = [Xbps(), Pacman()]

    for manager in managers:
        if manager.exists():
            return manager

    print("Package Manager not found")
    sys.exit(1)


def download_package() -> None:
    packages = ["neovim", "lldb", "python", "gcc", "clang", "ruff", "zathura", "zathura-pdf-poppler", "kitty", "typst", "pyright", "tinymist", "lua-language-server"]
    pm = find_manager()
    print(f"Manager is {pm.name}")

    for pkg in packages:
        if not pm.is_installed(pkg):
            if not pm.install(pkg):
                print(f"Failed to install package: {pkg}")
                sys.exit(1)

    for pkg in packages:
        if  pm.is_installed(pkg):
            print(f"Package: {pkg} exists")


def findNeovim() -> str:
    while True:
        stow = Path(home + ".dotfiles")
        userdir = sb.check_output(["ls", home + ".config"], text=True)
        if stow.is_dir():
            stowdir = sb.check_output(["ls", home + ".dotfiles/.config"], text=True)
        if "nvim" in stowdir.splitlines():
            nvimdir = str(stow) + "/.config/nvim"
            print(f"Nvim directory was found at {nvimdir}")
            break    
        elif "nvim" in userdir.splitlines():
            nvimdir = home + ".config/nvim"
            print(f"Nvim directory was found at {nvimdir}")
            break    
        else: 
            print("Nvim directory was NOT found")
            answer = input("Want to make new directory? [Y/n] ").strip().lower()
            match answer:
                case "y"|"":
                    if stow.is_dir():
                        result = sb.run(["mkdir", "-p", home + ".dotfiles/.config/nvim"])
                        if result.returncode == 0:
                            print("Created!")
                        else:
                            print("Failed to create directory")
                            sys.exit(1)
                    else:
                        result = sb.run(["mkdir", "-p", home + ".config/nvim"])
                        if result.returncode == 0:
                            print("Created!")
                        else:
                            print("Failed to create directory")
                            sys.exit(1)
                case "n":
                    print("Aborted!")
                    sys.exit()
                case _:
                    print("Command is not recognized")
                    continue
                
    return nvimdir    


def download() -> None:
    ndir = findNeovim()

    result = sb.run(["git", "fetch"])
    if result.returncode != 0:
        print("Git fetch failed")
        sys.exit(1)
    output = sb.check_output(["git", "status"], text=True)

    if "Your branch is behind" in output:
        print("Update")
        result = sb.run(["git", "pull"])
        if result.returncode != 0:
            print("Git pull failed")
            sys.exit(1)
    else:
        print("Nothing to update!")

    gdir = sb.check_output(["pwd"], text=True).strip()

    result = sb.run(["cp", "-r", gdir + "/config/.", ndir])
    if result.returncode == 0:
        print("Config copied successfully")
        print("Good luck with Pupamupa")
    else:
        print("Copy failed")
        sys.exit(1)


def main() -> None:
    download_package()
    download()


if __name__ == "__main__":
    main()
