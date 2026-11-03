def total_price(unit_price, quantity):
    if quantity < 1:
        raise ValueError("Quantity must be positive")
    return unit_price * quantity
