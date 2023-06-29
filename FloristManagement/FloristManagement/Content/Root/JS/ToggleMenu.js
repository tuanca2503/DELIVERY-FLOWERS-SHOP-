document.addEventListener('DOMContentLoaded', function() {

    var a = document.getElementsByClassName("_3Wo6fpk");
    //var EBCC = a[1].querySelector("._3dfrZFm").children[1]
    //function butCloseCart(b) {
    //    EBCC.addEventListener("click", function () {
    //        b.style.display = "none"
    //        console.log(b)
    //    })
    //}

    for (var i = 0; i < a.length; i++) {
        a[i].addEventListener("mouseenter", function () {
            var b = this.querySelector("._3iG3MJz").children[1]
            b.style.display = "flex"

        })
        a[i].addEventListener("mouseleave", function () {
            var b = this.querySelector("._3iG3MJz").children[1]
            b.style.display = "none"
        })
        a[i].addEventListener('click', function () {
            
            if (this.querySelector("._3iG3MJz").children[1].style.display == 'none') {
                this.querySelector("._3iG3MJz").children[1].style.display = 'flex'
            } else {
                this.querySelector("._3iG3MJz").children[1].style.display = 'none'
            }
        });


    }

    

   ////--myAccountDropdown
   //var myAccountDropdown = document.getElementById('myAccountDropdown')
   //myAccountDropdown.addEventListener("mouseenter", function() {
   //   this.children[1].style.display = 'flex'
   //   this.style.display = 'flex'
   //   // this.children.children.children.style.display = 'flex'

   //})
   //myAccountDropdown.addEventListener("mouseleave", function() {
   //   this.children[1].style.display = "none"
   //});

   //myAccountDropdown.addEventListener('click', function() {
   //   if(this.children[1].style.display == 'none'){
   //      this.children[1].style.display = 'flex'
   //   }else{
   //      this.children[1].style.display = 'none'
   //   }
   //});
   //--

    //var elements = document.getElementsByClassName('_2syfS2P');
    //for (var i = 0; i < elements.length; i++) {
    //   var element = elements[i];
       
    //   element.addEventListener("mouseenter", function() {
    //      var dataID = this.getAttribute("data-id")

    //      var child = document.getElementById(dataID);

    //      var inChild = child.children;
    //      inChild[0].style.display = "flex"

    //      inChild[0].addEventListener("mouseenter", function(){
    //         this.style.display = "flex";
    //      });
    //      inChild[0].addEventListener("mouseleave", function(){
    //         this.style.display = "none";
    //      });
    //      inChild[0].addEventListener('click', function() {
    //         this.style.display = "none";
    //      });
          
    //   });
    //   element.addEventListener("mouseleave", function() {
    //      var dataID = this.getAttribute("data-id")

    //      var child = document.getElementById(dataID);

    //      var inChild = child.children;
    //      inChild[0].style.display = "none"
    //   });
    //}

    });