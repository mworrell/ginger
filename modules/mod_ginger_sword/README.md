mod_ginger_sword
====================

A Zotonic module for uploading resources to a [SWORD](https://en.wikipedia.org/wiki/SWORD_%28protocol%29) endpoint.

This module is part of [Ginger](http://github.com/driebit/ginger). It depends on `mod_ginger_rdf`.

Configuration
-------------

Enable the module, then go to System > Config and enter values for the following keys:

* sword_url: the URL for the SWORD endpoint. Must include the protocol (`http://` or `https://`).
* slug_prefix: a prefix for the ID of the resources to upload to the SWORD endpoint. Handy if resources from multiple sites are pushed to the same slug endpoint.
* publish_sword: set to "true" to activate the module!
* publish_categories: a comma-separated list of resource categories to publish to the SWORD endpoint.
