//
//  Block+Extensions.swift
//  Walnut
//
//  Created by Joshua Grant on 7/23/21.
//

import Foundation

extension Block
{
    var textStyleType: TextStyle
    {
        get
        {
            .init(rawValue: textStyleTypeRaw)!
        }
        set
        {
            textStyleTypeRaw = newValue.rawValue
        }
    }

    var textSizeType: TextSize
    {
        get
        {
            .init(rawValue: textSizeTypeRaw)!
        }
        set
        {
            textSizeTypeRaw = newValue.rawValue
        }
    }
}

//extension ImageBlock: Searchable
//{
//    public static func predicate(for queryString: String) -> NSPredicate
//    {
//        makeCaptionPredicate(queryString)
//    }
//    
//    private static func makeCaptionPredicate(_ queryString: String) -> NSPredicate
//    {
//        NSPredicate(format: "content CONTAINS[cd] %@", queryString)
//    }
//}


//extension TextBlock
//{

//}
//
//extension TextBlock: Searchable
//{
//    public static func predicate(for queryString: String) -> NSPredicate
//    {
//        makeContentPredicate(queryString)
//    }
//    
//    private static func makeContentPredicate(_ queryString: String) -> NSPredicate
//    {
//        NSPredicate(format: "content CONTAINS[cd] %@", queryString)
//    }
//}
