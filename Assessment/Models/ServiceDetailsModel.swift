//
//  ServiceDetailsModel.swift
//  Assessment
//
//  Created by Naval Hasan on 01/12/20.
//  Copyright © 2020 Bankaks. All rights reserved.
//


import Foundation
struct ServiceDetailsModel : Codable {
    let status : String?
    let message : String?
    let result : Result?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case result = "result"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        result = try values.decodeIfPresent(Result.self, forKey: .result)
    }

}

struct Result : Codable {
    let number_of_fields : Int?
    let screen_title : String?
    let operator_name : String?
    let service_id : String?
    let fields : [Fields]?

    enum CodingKeys: String, CodingKey {

        case number_of_fields = "number_of_fields"
        case screen_title = "screen_title"
        case operator_name = "operator_name"
        case service_id = "service_id"
        case fields = "fields"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        number_of_fields = try values.decodeIfPresent(Int.self, forKey: .number_of_fields)
        screen_title = try values.decodeIfPresent(String.self, forKey: .screen_title)
        operator_name = try values.decodeIfPresent(String.self, forKey: .operator_name)
        service_id = try values.decodeIfPresent(String.self, forKey: .service_id)
        fields = try values.decodeIfPresent([Fields].self, forKey: .fields)
    }

}

struct Fields : Codable {
    let name : String?
    let placeholder : String?
    let regex : String?
    let type : Type?
    let is_mandatory : String?
    let hint_text : String?
    let ui_type : Ui_type?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case placeholder = "placeholder"
        case regex = "regex"
        case type = "type"
        case is_mandatory = "is_mandatory"
        case hint_text = "hint_text"
        case ui_type = "ui_type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        placeholder = try values.decodeIfPresent(String.self, forKey: .placeholder)
        regex = try values.decodeIfPresent(String.self, forKey: .regex)
        type = try values.decodeIfPresent(Type.self, forKey: .type)
        is_mandatory = try values.decodeIfPresent(String.self, forKey: .is_mandatory)
        hint_text = try values.decodeIfPresent(String.self, forKey: .hint_text)
        ui_type = try values.decodeIfPresent(Ui_type.self, forKey: .ui_type)
    }

}

struct Type : Codable {
    let data_type : String?
    let is_array : String?
    let array_name : String?

    enum CodingKeys: String, CodingKey {

        case data_type = "data_type"
        case is_array = "is_array"
        case array_name = "array_name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        data_type = try values.decodeIfPresent(String.self, forKey: .data_type)
        is_array = try values.decodeIfPresent(String.self, forKey: .is_array)
        array_name = try values.decodeIfPresent(String.self, forKey: .array_name)
    }

}

struct Ui_type : Codable {
    let type : String?
    let values : [Values]?

    enum CodingKeys: String, CodingKey {

        case type = "type"
        case values = "values"
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        type = try value.decodeIfPresent(String.self, forKey: .type)
        values = try value.decodeIfPresent([Values].self, forKey: .values)
    }

}

struct Values : Codable {
    let name : String?
    let id : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case id = "id"
    }

    init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        name = try value.decodeIfPresent(String.self, forKey: .name)
        id = try value.decodeIfPresent(String.self, forKey: .id)
    }

}
