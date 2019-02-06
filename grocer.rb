require 'pry'

def consolidate_cart(cart)
  cart_hash = {}
    cart.each do |array_element|
    array_element.each do |veggie, hash|
      cart_hash[veggie] ||= hash
      cart_hash[veggie][:count] ||= 0
      cart_hash[veggie][:count] += 1
    end
  end
  cart_hash
end

def apply_coupons(cart, coupons)
  if coupons.length > 0
      coupons.each do |coupon_info|
        if cart.key?(coupon_info[:item])
          if cart[coupon_info[:item]][:count] >= coupon_info[:num]
          if cart.key?("#{coupon_info[:item]} W/COUPON")
            cart["#{coupon_info[:item]} W/COUPON"][:count] += 1
            cart[coupon_info[:item]][:count] -= coupon_info[:num]
          else
            cart["#{coupon_info[:item]} W/COUPON"] = {}
            cart["#{coupon_info[:item]} W/COUPON"][:price] = coupon_info[:cost]
            cart["#{coupon_info[:item]} W/COUPON"][:count] = 1
            cart[coupon_info[:item]][:count] -= coupon_info[:num]
            cart["#{coupon_info[:item]} W/COUPON"][:clearance] = cart[coupon_info[:item]][:clearance]
          end
        end
        end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.map do |cart_item, item_hash|
    if item_hash[:clearance] == true
      item_hash[:price] = item_hash[:price] - (item_hash[:price] * 0.200)
    end
  end
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  cart = apply_coupons(cart, coupons)
  cart = apply_clearance(cart)
  cart_total = 0
  cart.each do |item, values|
    cart_total += (values[:count] * values[:price])
  end
  if cart_total > 100
     cart_total = cart_total - (cart_total * 0.100)
  end
  cart_total
end
