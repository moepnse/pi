# -*- coding: utf-8 -*-

# standard library imports
import imp
import os

# third party imports

# application/library imports


class PluginSystem(object):

    def __init__(self, plugin_path=r"C:\pi_cython\plugins", log=None):
        self._plugin_path = plugin_path
        self._log = log

    def _get_plugins(self, file_extension):
        plugins = self._plugins
        suffix_len = len(file_extension)
        for plugin_file_name in os.listdir(self._plugin_path):
            if not plugin_file_name.endswith(file_extension):
                continue
            if self._log is not None:
                self._log.log_info(u'%s %s %s' % (self._plugin_path, plugin_path, plugin_name))
            plugin_name = plugin_file_name[:-suffix_len]
            plugin_path = os.path.join(self._plugin_path, plugin_file_name)
            if self._log is not None:
                self._log.log_info(u'%s %s %s' % (self._plugin_path, plugin_path, plugin_name))
            #plugin = imp.find_module(plugin_name, [self._plugin_path])
            #print plugin_name, plugin_path
            plugins[plugin_name] = (plugin_name, plugin_path)

    def get_plugins(self):
        self._plugins = {}
        self._get_plugins('.pyc')
        self._get_plugins('.py')
        self._get_plugins('.pyd')
        self._get_plugins('.so')
        return self._plugins

    def load_plugin(self, plugin):
        plugin_path = plugin[1]
        print plugin_path
        head, tail = os.path.split(plugin_path)
        if tail.endswith('.py'):
            plugin = imp.load_source(*plugin)
        elif tail.endswith('.pyd') or (tail.endswith('.so') and not tail.startswith('lib')):
            try:
                plugin = imp.load_dynamic(*plugin)
            except ImportError, err:
                print plugin_path, err
        elif tail.endswith('.pyc'):
            plugin = imp.load_compiled(*plugin)
        return plugin

    def load_plugins(self):
        plugins = []
        for plugin in self.get_plugins().values():
            plugins.append(self.load_plugin(plugin))
        return plugins