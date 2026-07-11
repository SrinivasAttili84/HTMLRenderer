function toggle(id){

    var x=document.getElementById(id);

    if(x.style.display==="none"){

        x.style.display="block";

    }else{

        x.style.display="none";

    }

}

function openReference(ref){

    window.location.href="reference://"+ref;

}

function openEquipment(id){

    window.location.href="equipment://"+id;

}
