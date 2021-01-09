class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = Array.new

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end

    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)

    elsif req.path.match(/cart/)
      if @@cart.empty?
        resp.write "Your cart is empty"
      else
        @@cart.each do |cart_item|
          resp.write "#{cart_item}\n"
        end 
      end

    elsif req.path.match(/add/)
      new_item = req.params["item"]
      resp.write handle_add(new_item)
    else
      resp.write "Path Not Found"
    end

    resp.finish
  end


  def handle_add(new_item)
    if @@items.include?(new_item)
      @@cart << new_item
      "added #{new_item}"
    else
      "We don't have that item"
    end
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
