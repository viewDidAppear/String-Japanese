//
//  String_JapaneseTests.swift
//  String+JapaneseTests
//
//  Created by Ben Deckys on 9/3/18.
//  Copyright © 2018 topLayoutGuide. All rights reserved.
//

import XCTest
@testable import String_Japanese

class String_JapaneseTests: XCTestCase {
	
	let katakanaString = "カタカナ"
	let hiraganaString = "ひらがな"
	let kanjiString = "東京"
	let containsJapaneseString = "日本の歴史や文化が大好きです。"
	let fullWidthRomajiString = "Ｓｕｇｏｉ"
	let fullWidthNumericalString = "１０００００１"
	let hankakuKatakanaString = "ｶﾀｶﾅ"
	let romajiString = "Sugoidesune"
	
	func testKatakana() {
		XCTAssert(katakanaString.isKatakana)
	}
	
	func testHiragana() {
		XCTAssert(hiraganaString.isHiragana)
	}
	
	func testKanji() {
		XCTAssert(kanjiString.isKanji)
	}
	
	func testJapanese() {
		XCTAssert(containsJapaneseString.containsJapanese)
	}
	
	func testFullWidthRomaji() {
		XCTAssert(fullWidthRomajiString.isZenkakuRomaji)
	}
	
	func testFullWidthNumerical() {
		XCTAssert(fullWidthNumericalString.isZenkakuNumerical)
	}
	
	func testKanjiTransliteration() {
		XCTAssert(kanjiString.toRomaji == "toukyou")
	}
	
	func testKatakanaTransliteration() {
		XCTAssert(katakanaString.toRomaji == "katakana")
	}
	
	func testHiraganaTransliteration() {
		XCTAssert(hiraganaString.toRomaji == "hiragana")
	}
	
	func testJapaneseTransliteration() {
		XCTAssert(containsJapaneseString.toRomaji == "nipponnorekishiyabunkagadaisukidesu")
	}
	
	func testJapaneseTransliterationWithSeparator() {
		XCTAssert(containsJapaneseString.toRomaji(withSeparator: " ") == "nippon no rekishi ya bunka ga daisuki desu")
	}
	
	func testRomajiToHiragana() {
		XCTAssert(romajiString.romajiToHiragana == "すごいですね")
	}
	
	func testRomajiToKatakana() {
		XCTAssert(romajiString.romajiToKatakana == "スゴイデスネ")
	}
	
	func testHankakuKatakana() {
		XCTAssert(hankakuKatakanaString.isHankakuKatakana)
	}
	
}
