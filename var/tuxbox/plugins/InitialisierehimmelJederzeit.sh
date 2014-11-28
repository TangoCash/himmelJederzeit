#!/bin/sh
echo "Die Grundstruktur f&uuml;r himmelJederzeit wird erzeugt"
cd /var/tuxbox/plugins;./himmelJederzeit.sh initGUI
echo "Dieses Script wird deaktiviert"
sed -e 's#hide=0#hide=1#' /var/tuxbox/plugins/InitialisierehimmelJederzeit.cfg > /var/tuxbox/plugins/tmp && mv /var/tuxbox/plugins/tmp /var/tuxbox/plugins/InitialisierehimmelJederzeit.cfg
cd /var/tuxbox/plugins;./himmelJederzeit.sh full
