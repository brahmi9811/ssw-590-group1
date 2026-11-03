import unittest
from pricing import total_price


class PricingTests(unittest.TestCase):
    def test_total(self):
        self.assertEqual(total_price(10, 3), 30)

    def test_invalid_quantity(self):
        with self.assertRaises(ValueError):
            total_price(10, 0)
