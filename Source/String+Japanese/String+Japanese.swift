/*
		MIT License

		Copyright (c) 2018 Benjamin Dietzkis

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
*/

import UIKit.UITextChecker
import Foundation

extension String {
	
	enum JapaneseType {
		case hiragana
		case katakana
		case hankakuKatakana
		case compound
		case kanji
		case hoka
	}
	
	enum CharacterClass {
		case kuuhaku
		case hoka
		case hiragana
		case katakana
		case kanji
		case kuten
		case touten
		case kigou
		case hankakuKatakana
		case zenkakuRomaji
		case zenkakuSuujishuugou
		case ascii
	}
	
	/*
	+    Character Unicode
	+
	+    ひらがな | Hiragana:
	+        Hiragana: 3040-309F
	+
	+    カタカナ | Katakana:
	+        Katakana: 30A0-30FF (except 30FB: KATAKANA MIDDLE DOT)
	+        Halfwidth and Fullwidth Forms (FF00-FFEF): FF66-FF9F
	+        * Katakana Phonetic Extensions: 31F0-31FF
	+
	+    漢字 | Kanji:
	+        CJK Radicals Supplement: 2E80-2EFF
	+        Kangxi Radicals: 2F00-2FDF
	+        CJK Unified Ideographs: 4E00-9FAF
	+        * Ideographic Description Characters: 2FF0-2FFF
	+        * CJK Unified Ideographs Extension A: 3400-4DBF
	+        * CJK Compatibility Ideographs: F900-FAFF
	+
	+    記号 | Kigou:
	+        * Arrows: 2190-21FF
	+        * Mathematical Operators: 2200-22FF
	+        * Box Drawing: 2500-257F
	+        * Geometric Shapes: 25A0-25FF
	+        * Miscellaneous Symbols: 2600-26FF
	+        * CJK Symbols and Punctuation (3000-303F): 3003-303F
	+        * Enclosed CJK Letters and Months: 3200-32FF
	+        * CJK Compatibility: 3300-33FF
	+        * CJK Compatibility Forms: FE30-FE4F
	+        * Half and Full-width Forms: (FF00-FFEF): FF5F-FF60, FF62-FF63, FFE0-FFF6, FFE8-FFEE
	+        * and others?
	+
	+    空白 | Space:
	+        C0 Controls and Basic Latin (0000-007F): 0020
	+        CJK Symbols and Punctuation (3000-303F): 3000
	+
	+    句点 | Period:
	+        CJK Symbols and Punctuation (3000-303F): 3001
	+        Halfwidth and Fullwidth Forms (FF00-FFEF): FF0E, FF64
	+
	+    読点 | Comma:
	+        CJK Symbols and Punctuation (3000-303F): 3002
	+        Halfwidth and Fullwidth Forms (FF00-FFEF): FF0C, FF61
	+
	+    全角ローマ字 | Full-width Latin Characters:
	+        Halfwidth and Fullwidth Forms (FF00-FFEF): FF01-FF5E (correspond to 0021-007E)
	+
	+    全角数字集合 | Full-width Numerals:
	+        Halfwidth and Fullwidth Forms (FF00-FFEF): FF10-FF19
	+
	+    半角カタカナ | Half-width Katakana:
	+        Halfwidth Forms (FF61-FFEF): FF10-FF9F
	+
	+    see http://www.unicode.org/charts/
	+    and https://www.sljfaq.org/afaq/half-width-katakana.html
	+
	*/
	
	private func characterClass(for char: UniChar) -> CharacterClass {
		if char.isHiragana {
			return .hiragana
		} else if char.isKatakana {
			return .katakana
		} else if char.isKanji {
			return .kanji
		} else if char.isKuten {
			return .kuten
		} else if char.isTouten {
			return .touten
		} else if char.isKuuhaku {
			return .kuuhaku
		} else if char.isZenkakuRomaji {
			return .zenkakuRomaji
		} else if char.isZenkakuNumerical {
			return .zenkakuSuujishuugou
		} else if char.isHankakuKatakana {
			return .hankakuKatakana
		} else {
			return .hoka
		}
	}
	
	private func japaneseType(of string: String) -> JapaneseType {
		var lastCharClass: CharacterClass = .hoka
		
		for i in 0..<string.count {
				let char = string.utf16[i]
				let charClass = characterClass(for: char)
			
			if i == 0 {
					lastCharClass = charClass
			} else {
				if lastCharClass != charClass {
					if charClass == .katakana || charClass == .hiragana || charClass == .kanji || charClass == .hankakuKatakana {
							return .compound
					}
					
					return .hoka
				}
			}
				
		}

		if lastCharClass == .hiragana {
			return .hiragana
		} else if lastCharClass == .katakana {
			return .katakana
		} else if lastCharClass == .kanji {
			return .kanji
		} else if lastCharClass == .hankakuKatakana {
			return .hankakuKatakana
		}
		
		return .hoka
	}
	
	/// Return an optionally token-delimited Latin representation of self, where self contains identifiable Japanese text.
	/// Use of custom transliteration rules is recommended when you expect alternate readings of words. Example: You expect なん instead of みなみ (Nan, as opposed to Minami).
	///
	/// - Parameter separator: Supply an optional separator.
	/// - Returns: An optionally token-delimited Latin representation of self.
	func toRomaji(withSeparator separator: String = "") -> String {
		var result = ""
		var token = CFStringTokenizerCreate(
			kCFAllocatorDefault,
			self as CFString,
			CFRangeMake(0, self.count),
			kCFStringTokenizerUnitWord,
			CFLocaleCreate(kCFAllocatorDefault, CFLocaleIdentifier("Japanese" as CFString))
		)
		
		var tokenType: CFStringTokenizerTokenType = CFStringTokenizerGoToTokenAtIndex(token, 0)
		
		while tokenType.rawValue != 0 {
			let ref = CFStringTokenizerCopyCurrentTokenAttribute(token, kCFStringTokenizerAttributeLatinTranscription)
			guard let stringRef = ref as? String else { return result }
			
			if separator.isEmpty == false {
				result.append(result.isEmpty ? stringRef : separator + stringRef)
			} else {
				result.append(stringRef)
			}
			
			tokenType = CFStringTokenizerAdvanceToNextToken(token)
		}
		
		token = nil
		return result
	}
	
	/// Return a representation of self, where self contains identifiable Japanese text, and all Kanji have been transliterated to Hiragana.
	/// Use of custom transliteration rules is recommended when you expect alternate readings of words. Example: You expect なん instead of みなみ.
	var replacingKanjiWithHiragana: String {
		var result = ""
		var token = CFStringTokenizerCreate(
			kCFAllocatorDefault,
			self as CFString,
			CFRangeMake(0, self.count),
			kCFStringTokenizerUnitWord,
			CFLocaleCreate(kCFAllocatorDefault, CFLocaleIdentifier("Japanese" as CFString))
		)
		
		var tokenType: CFStringTokenizerTokenType = CFStringTokenizerGoToTokenAtIndex(token, 0)
		
		while tokenType.rawValue != 0 {
			let currentRange = CFStringTokenizerGetCurrentTokenRange(token)
			let substring = self[currentRange.location..<currentRange.location+currentRange.length]
			let type = japaneseType(of: substring)
			
			if type == .kanji || type == .compound {
				result.append(substring.toHiragana)
			} else {
				result.append(substring)
			}
			
			tokenType = CFStringTokenizerAdvanceToNextToken(token)
		}
		
		token = nil
		return result
	}
	
	/// Determine if the analyzed String contains any valid Japanese characters.
	var containsJapanese: Bool {
		return self.utf16.reduce(true) { $0 && $1.isSpecificToJapanese || $1.isKanji }
	}
	
	/// Determine if the analyzed String contains Katakana characters.
	var isKatakana: Bool {
		return self.utf16.reduce(true) { $0 && $1.isKatakana }
	}
	
	/// Determine if the analyzed String contains Hiragana characters.
	var isHiragana: Bool {
		return self.utf16.reduce(true) { $0 && $1.isHiragana }
	}
	
	/// Determine if the analyzed String contains Kanji characters.
	var isKanji: Bool {
		return self.utf16.reduce(true) { $0 && $1.isKanji }
	}
	
	/// Determine if the analyzed String contains full-width Numerical characters.
	var isZenkakuNumerical: Bool {
		return self.utf16.reduce(true) { $0 && $1.isZenkakuNumerical }
	}
	
	/// Determine if the analyzed String contains full-width Latin characters.
	var isZenkakuRomaji: Bool {
		return self.utf16.reduce(true) { $0 && $1.isZenkakuRomaji }
	}
	
	/// Determine if the analyzed String contains half-width Katakana characters.
	var isHankakuKatakana: Bool {
		return self.utf16.reduce(true) { $0 && $1.isHankakuKatakana }
	}
	
	/// Return a Latin representation of self, where self contains identifiable Japanese text.
	/// Use of custom transliteration rules is recommended when you expect alternate readings of words. Example: You expect なん instead of みなみ (Nan, as opposed to Minami).
	var toRomaji: String {
		guard containsJapanese else { return self }
		return toRomaji()
	}
	
	/// Return a ひらがな representation of self, where self contains identifiable Japanese text.
	var toHiragana: String {
		guard containsJapanese else { return self }
		return toRomaji().applyingTransform(StringTransform.latinToHiragana, reverse: false) ?? self
	}
	
	/// Return a カタカナ representation of self, where self contains identifiable Japanese text.
	var toKatakana: String {
		guard containsJapanese else { return self }
		return toRomaji().applyingTransform(StringTransform.latinToKatakana, reverse: false) ?? self
	}
	
	/// Return a ひらがな representation of self. This is by *no means* guaranteed to be accurate.
	var romajiToHiragana: String {
		return self.applyingTransform(StringTransform.latinToHiragana, reverse: false) ?? self
	}
	
	/// Return a カタカナ representation of self. This is by *no means* guaranteed to be accurate.
	var romajiToKatakana: String {
		return self.applyingTransform(StringTransform.latinToKatakana, reverse: false) ?? self
	}
	
}
