

class window.TemplateLoader

      cache: {}

      get: (name, callback) ->

        if name of this.cache
            callback(this.cache[name])
            return

        template_uri = "/templates/" + name




        if template_uri of window._template_cache
            this.cache[name] = _.template(window._template_cache[template_uri])
            callback(this.cache[name])
            return

        promise = $.trafficCop(template_uri)

        promise.done( (result) =>
            this.cache[name] = _.template(result)

            callback(this.cache[name])
        )

window.template_loader = new window.TemplateLoader()