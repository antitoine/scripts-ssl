<?php 
/* Pour afficher l'annonce sur un site, rajouter la ligne suivante dans le contenu, de préférence après le body :
    <?php include "annonce-site-vitrine.php"; ?>
   Il faut aussi que le fichier annonce soit a la même racine que le fichier ou a été rajouté la ligne.
*/ ?>

<script>
  window.onload=function initClose()
  {
    var name = "AnnonceClose=";
    var result = "";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++)
    {
        var c = ca[i].trim();
        if (c.indexOf(name)==0) {
            result = c.substring(name.length,c.length);
            break;
        }
    }
    if (result == "")
    {
       document.getElementById("gigaban").style.display="block";
    }
  };
  function closeAnnonce()
  {
    document.getElementById("gigaban").style.display="none";
    var d = new Date();
    d.setTime(d.getTime()+(1*60*60*1000));
    var expires = "expires="+d.toGMTString();
    document.cookie = "AnnonceClose=true; " + expires;
  }
</script>
<div id="gigaban" style="background:rgba(0, 0, 0, 0.8);display:none;font-size:1.3em;padding:10px 5px 5px 5px;position:fixed;text-align:center;width:100%;z-index:999;top: 0;">
    <button onclick="closeAnnonce()" style="float:right;margin-right:20px;">Fermer</button>
    <p> 
        Ceci est un site vitrine, il sert donc uniquement à montrer le travail graphique qui a été réalisé.
        <a href="http://www.antoine-chabert.fr" target="_blank">Plus d'infos</a>
    </p>
</div>
