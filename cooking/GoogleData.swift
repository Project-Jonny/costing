
import Foundation

        struct GoogleData: Decodable {
            let name: String
            let amount: String
            let unit: String
            let price: String
            let category: String

            private enum CodingKeys: String, CodingKey {
                case name
                case amount
                case unit
                case price
                case category
            }
        }
