import pynvim
from pynvim.api.nvim import Nvim
from urllib.request import urlopen
import json
import subprocess
import os
from pathlib import Path

ALL_MODULES = "ALL_MODULES"


def cache_k8s_module(cache_file):
    with open(cache_file, "r") as fp:
        ret = [_.lstrip("./staging/src/")
               for _ in fp.read().split() if "./staging/src/" in _]
        ret.append(ALL_MODULES)
        return ret


def cache_k8s_mod_info(cache_file):
    with open(cache_file, "rb") as fp:
        return json.load(fp)


@pynvim.plugin
class CodeActionGolangK8s(object):
    def __init__(self, nvim: Nvim):
        self.nvim = nvim
        self.mod_api = "https://raw.githubusercontent.com/kubernetes/kubernetes/v{}/go.mod"
        self.cache_dir = os.path.join(
            Path.home(), ".config/nvim/rplugin/python/cache/k8s")

    @pynvim.function(name="K8sAllModules", sync=True)
    def gather_all_k8s_modules(self, k8s_version):
        if len(k8s_version) != 1:
            return None
        k8s_version = k8s_version[0]
        cache_file = os.path.join(
            self.cache_dir, "{}/go.mod".format(k8s_version))
        #read mod info from cache file directory,if relatived cache file existed
        if os.path.exists(cache_file):
            return cache_k8s_module(cache_file=os.path.join(self.cache_dir, "{}/go.mod".format(k8s_version)))
        try:
            response = urlopen(self.mod_api.format(
                k8s_version), timeout=20).read().decode("utf-8")
        except Exception as error:
            return None
        if not os.path.exists(os.path.join(self.cache_dir, "{}".format(k8s_version))):
            os.mkdir(os.path.join(self.cache_dir, "{}".format(k8s_version)))
        with open(cache_file, "wb") as writer:
            writer.write(response)
        modules = set(ALL_MODULES)
        [modules.add(_.strip("./staging/src/"))
         for _ in response.split() if "./staging/src/" in _]
        return modules

    @pynvim.command("CacheK8sClean")
    def clear_cache(self):
        subprocess.getstatusoutput("rm -rf {}".format(self.cache_dir))

    @pynvim.command("CacheK8sInit")
    def cache_all_information(self, k8s_version):
        if len(k8s_version) != 1:
            return None
        k8s_version = k8s_version[0]
        k8s_action = CodeActionGolangK8s()
        for sig_mod in k8s_action.gather_all_k8s_modules(k8s_version):
            k8s.download(sig_mod, k8s_version)

    @pynvim.function(name="K8sModDownload", sync=True)
    def k8s_mod_download(self, args):
        mod_name = args[0]
        version = args[1]
        if ALL_MODULES == mod_name:
            mod_install_list = self.gather_all_k8s_modules([version])
            if not mod_install_list:
                return None
        else:
            mod_install_list = [mod_name]
        for sig_mod in mod_install_list:
            self.go_mod_add_pkg(sig_mod, version)
        return "OK"

    def go_mod_add_pkg(self, mod_name, version):
        cache_file = os.path.join(
            self.cache_dir, "{}/{}.json".format(version, mod_name.split("/")[-1]))
        if os.path.exists(cache_file):
            json_data = cache_k8s_mod_info(cache_file)
        else:
            try:
                cmd = 'go mod download -json "{}@kubernetes-{}"'.format(
                    mod_name, version)
                code, resp = subprocess.getstatusoutput(cmd)
                if code:
                    return None
                json_data = json.loads(resp)
            except Exception as error:
                return None
            with open(cache_file, "w+") as cache_fp:
                json.dump(json_data, cache_fp)
            # with open(cache_file,"wb") as fp:
            #     json.dump(json_data, fp)
        version = json_data.get("Version")
        cmd = 'go mod edit "-replace={MOD_NAME}={MOD_NAME}@{VERSION}"'.format(
            MOD_NAME=mod_name, VERSION=version)
        code, _ = subprocess.getstatusoutput(cmd)
        if code:
            return None
        return "Ok"


if __name__ == '__main__':
    k8s = CodeActionGolangK8s()
    all_modes = k8s.gather_all_k8s_modules(["1.16.0"])
    a = k8s.k8s_mod_download([ALL_MODULES, "1.16.0"])
    print(a)
