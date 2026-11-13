import os
import unittest

import app as app_module
from app import app, total_price


class PricingTests(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_price(self):
        self.assertEqual(total_price(3), 30)
        response = self.client.get("/price?quantity=3")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response.json["total"], 30)

    def test_invalid_quantity(self):
        for value in ["0", "-1", "1001", "abc", "1.5"]:
            self.assertEqual(self.client.get("/price?quantity=" + value).status_code, 400)

    def test_release_identity(self):
        self.assertEqual(self.client.get("/").json["version"], "v1")
        self.assertEqual(self.client.get("/health").json["status"], "ok")

    def test_version_file_matches_app(self):
        # Group 1 addition: the pipeline reads pricing-service/VERSION to name the release record,
        # so it must always equal the version the application reports.
        version_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), "VERSION")
        with open(version_file) as handle:
            self.assertEqual(handle.read().strip(), app_module.VERSION)


if __name__ == "__main__":
    unittest.main()
