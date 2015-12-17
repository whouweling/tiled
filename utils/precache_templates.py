#!/usr/bin/python
import os
import json
import pyinotify


from os.path import join, getsize

class PTmp(pyinotify.ProcessEvent):
    """Event handler"""
    def process_IN_CREATE(self, event):
        """Capture events for the CREATE event."""
        print "Create: ", event.pathname

    def process_default(self,event):
        """Default handler for ALLOTHER events."""
        print "Default handler hit: ", event.pathname

def update_cache(notifierObj):
    cache = {}

    for root, dirs, files in os.walk('templates'):
        
        for file in files:
            filename = join(root, file)
            try:
              f = open(filename, "r")

              cache["/%s" % filename] = f.read()
            except:
              pass

    cache_file = open("js/_template_cache.js", "w")
    cache_file.write("window._template_cache = %s;" % json.dumps(cache))

    print "Cache updated."


wm = pyinotify.WatchManager()
mask = pyinotify.IN_CREATE | pyinotify.IN_DELETE | pyinotify.IN_MODIFY

notifier = pyinotify.Notifier(wm, PTmp())
path = 'templates'
wm.add_watch(path, mask, rec=True)

notifier.loop(callback=update_cache)

