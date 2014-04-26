module RelateIQ
  class APIResource < RiqObject
    def self.name
      n = self.to_s.split('::')[-1]
      # Hyphenize
      n.scan(/([A-Z][a-z]*)/).join('-').downcase
    end

    def self.find(id, params = {}, url = nil)
      path = url.nil? ? "#{plural}/#{id}" : url
      instance = self.new(id)
      response = RelateIQ.get(path, params)
      instance.refresh_from(response)
      instance
    end

    def self.all(params = {}, url = nil)
      params = {} unless params.is_a? Hash
      path = url.nil? ? plural : url
      response = RelateIQ.get(path, params)
      objects = response['objects'] || []
      list = Array.new
      objects.each do |v|
        if v.class == Hash && v['id'].nil?
          c = self.new(v['id'])
        else
          c = self.new
        end
        c.refresh_from(v)
        list.push(c)
      end
      return RiqList.new(list)
    end

    def update(params = {})
      path = "#{plural}/#{self.id}"
      p = { self.name => params }.to_json
      response = RelateIQ.put(path, params.to_json)
    end

    def self.update(id, params = {})
      path = "#{plural}/#{id}"
      p = { self.name => params }.to_json
      response = RelateIQ.put(path, p)
    end


    def create(params = {})
      path = "#{plural}/#{self.id}"
      response = RelateIQ.post(path, params.to_json)
      self.refresh_from(response)
    end

    def delete(params = {})
      path = "#{plural}/#{self.id}"
      RelateIQ.delete(path)
    end

    def self.delete(id, params = {})
      path = "#{plural}/#{id}"
      RelateIQ.delete(path)
    end

    def plural
      "#{self.class.name}s"
    end

    def self.plural
      "#{name}s"
    end
  end
end

