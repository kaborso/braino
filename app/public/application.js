window.onload = function () {
  if(history.state !== null && history.state.url !== undefined) {
    document.querySelector("#output img").src = history.state.url;
  }
  var braino = new Vue({
   el: '#input',
    data: {
      brain_1: "",
      brain_2: "",
      brain_3: "",
      brain_4: "",
      image: null
    },
    computed: {
      brains: function (val) {
        var naked_brains = [this.brain_1, this.brain_2, this.brain_3, this.brain_4];
        var wrapped_brains = naked_brains.map(function(string){
          return {text: string};
        })
        return wrapped_brains;
      }
    },
    methods: {
      generate: function () {
        var self = this
        var xhr = new XMLHttpRequest()
        xhr.open('POST', "/expanding_brain.json")
        xhr.setRequestHeader('accept', 'application/json')
        xhr.setRequestHeader('content-type', 'application/json')
        xhr.onload = function () {
          self.image = JSON.parse(xhr.responseText)
          history.pushState(self.image, "Braino - " + self.image.name, "#" + self.image.name)
          document.querySelector("#output img").src = self.image.url
        }
        xhr.send(JSON.stringify({"brains": self.brains}))
      }
    }
  });

}
