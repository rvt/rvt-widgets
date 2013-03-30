RVT Widgets
===========

RVT Widgets is a widget system to allow personalized pages for logged in users. It's like iGoogle and others where a user can add/remove widgets in various columns and move them around using drag and drop.

Note: THis widgets system was inspored and cloned from the Jahia portal system.


Installation
============

Using mvn package compile the module into a war and copy the resulting war archove into Jahia's shared_module directory.
Alternative you can use the deployModule.sh script to deploy the module.
It requires a restart of Jahia.


Usage
=====
1. Add the module **Widget placeholder** to the content repository using the content manager. This will be used as a template for any new user that is going
to initialise there homepage.
1. Create a folder in the content repository where you can add your widgets, you can use any module (as far as I know) but it must have a proper title (hint, use **maint content** instead of **Rich Text**)
1. Add the modules **User widget renderer** and **Widgets Customizer** to the page where you want the user to customize it's place.


How to create a template
========================
Create a empty page outside of you page tree and create a reverense to the **Widget Placeholder** now you can drag/drop other content items in each column.
Suggested is to use only content items from the folder created in 2.


Support
=======
If you want to have support for this module, please don't hessitate and contact me.


Module Status
=============
This module is currently in beta, it is used in a project, but not deployed yet at large scale.

TODO
====
Test for the number of widgets during removal when allowRemovable is selected, this correctly done in selectChecked view
Code Cleanup...


R. van Twisk
http://riesvantwisk.com






