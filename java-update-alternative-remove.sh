#! /bin/sh

if [ "$(id -u)" != "0" ]; then
   echo -e "$ROUGE""Ce script doit être lancé en root (avec les droits administrateurs)" 1>&2
   exit 1
fi

JAVA_FOLDER=/opt/java/jdk1.8.0_66

update-alternatives --remove java $JAVA_FOLDER/bin/java
update-alternatives --remove keytool $JAVA_FOLDER/bin/keytool
update-alternatives --remove pack200 $JAVA_FOLDER/bin/pack200
update-alternatives --remove rmid $JAVA_FOLDER/bin/rmid
update-alternatives --remove rmiregistry $JAVA_FOLDER/bin/rmiregistry
update-alternatives --remove unpack200 $JAVA_FOLDER/bin/unpack200
update-alternatives --remove orbd $JAVA_FOLDER/bin/orbd
update-alternatives --remove servertool $JAVA_FOLDER/bin/servertool
update-alternatives --remove tnameserv $JAVA_FOLDER/bin/tnameserv
update-alternatives --remove policytool $JAVA_FOLDER/bin/policytool
update-alternatives --remove appletviewer $JAVA_FOLDER/bin/appletviewer
update-alternatives --remove extcheck $JAVA_FOLDER/bin/extcheck
update-alternatives --remove idlj $JAVA_FOLDER/bin/idlj
update-alternatives --remove jar $JAVA_FOLDER/bin/jar
update-alternatives --remove jarsigner $JAVA_FOLDER/bin/jarsigner
update-alternatives --remove javac $JAVA_FOLDER/bin/javac
update-alternatives --remove javadoc $JAVA_FOLDER/bin/javadoc
update-alternatives --remove javah $JAVA_FOLDER/bin/javah
update-alternatives --remove javap $JAVA_FOLDER/bin/javap
update-alternatives --remove jcmd $JAVA_FOLDER/bin/jcmd
update-alternatives --remove jconsole $JAVA_FOLDER/bin/jconsole
update-alternatives --remove jdb $JAVA_FOLDER/bin/jdb
update-alternatives --remove jhat $JAVA_FOLDER/bin/jhat
update-alternatives --remove jinfo $JAVA_FOLDER/bin/jinfo
update-alternatives --remove jmap $JAVA_FOLDER/bin/jmap
update-alternatives --remove jps $JAVA_FOLDER/bin/jps
update-alternatives --remove jrunscript $JAVA_FOLDER/bin/jrunscript
update-alternatives --remove jsadebugd $JAVA_FOLDER/bin/jsadebugd
update-alternatives --remove jstack $JAVA_FOLDER/bin/jstack
update-alternatives --remove jstat $JAVA_FOLDER/bin/jstat
update-alternatives --remove jstatd $JAVA_FOLDER/bin/jstatd
update-alternatives --remove native2ascii $JAVA_FOLDER/bin/native2ascii
update-alternatives --remove rmic $JAVA_FOLDER/bin/rmic
update-alternatives --remove schemagen $JAVA_FOLDER/bin/schemagen
update-alternatives --remove wsgen $JAVA_FOLDER/bin/wsgen
update-alternatives --remove wsimport $JAVA_FOLDER/bin/wsimport
update-alternatives --remove xjc $JAVA_FOLDER/bin/xjc
update-alternatives --remove jexec $JAVA_FOLDER/jre/lib/jexec
