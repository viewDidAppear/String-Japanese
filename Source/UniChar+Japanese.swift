/*
		MIT License

		Copyright (c) 2020 Benjamin Dietzkis

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

import Foundation

extension UniChar {

	// MARK: - Unicode Helper Functions
	
	private func inRange(_ char: UniChar, lowerBound: UniChar, upperBound: UniChar) -> Bool {
		(lowerBound <= char) && (char <= upperBound)
	}
	
	// MARK: - Syllabilic Character Sets

	var isHiragana: Bool {
		inRange(self, lowerBound: 0x3040, upperBound: 0x309F)
	}
	
	var isKatakana: Bool {
		inRange(self, lowerBound: 0x30A0, upperBound: 0x30FF) && (self != 0x30FB || inRange(self, lowerBound: 0xFF66, upperBound: 0xFF9F))
	}
	
	// MARK: - 漢字 | Chinese-origin Characters
	
	var isKanji: Bool {
		(inRange(self, lowerBound: 0x2E80, upperBound: 0x2EFF) || inRange(self, lowerBound: 0x2F00, upperBound: 0x2FDF) || inRange(self, lowerBound: 0x4E00, upperBound: 0x9FAF))
	}
	
	// MARK: - PunctuationCircular Period, Comma, Space

    /// "Kuten" meaning "empty mark" is the circular period mark used in the Japanese language
    /// It appears as so 　→　 。
	var isKuten: Bool {
		self == 0x3001 || self == 0xFF64 || self == 0xFF0E
	}

    /// "Touten" meaning "reading mark" is the reverse direction (to English) comma used in the Japanese language
    /// It appears as so 　→　 、
	var isTouten: Bool {
		return self == 0x3002 || self == 0xFF61 || self == 0xFF0C
	}

    /// "Kuuhaku" meaning "empty space" or just "space" is the Japanese equivalent of a whitespace character.
    /// It is always represented in Zenkaku, meaning it occupies the same amount of space as a regular Hiragana, Katakana or Kanji.
	var isKuuhaku: Bool {
		return self == 0x3000
	}
	
	// MARK: - Half-width Katakana, Full-width Romaji, Full-width Numeric

    /// "Hankaku Katakana" meaning "half-width angular Japanese syllable" is a half-standard width rendering of an ordinary Katakana glyph.
    /// Katakana is almost exclusively used to represent foreign loan words, and as such they can wind up quite long.
    /// A half width example would be ｺﾝﾋﾞﾆ as opposed to コンビニ
	var isHankakuKatakana: Bool {
		return inRange(self, lowerBound: 0xFF61, upperBound: 0xFF9F)
	}

    /// "Zenkaku Romaji" meaning "full-width roman charater" is a roman character which takes up the same amount of space as a standard Japanese glyph.
    /// 例えば、この分にはｆｕｌｌ　ｗｉｄｔｈ字が入ってます。
	var isZenkakuRomaji: Bool {
		return inRange(self, lowerBound: 0xFF01, upperBound: 0xFF5E)
	}

    /// "Zenkaku Numerical" meaning "full-width numerical character" is an arabic numeral which takes up the same amount of space as a standard Japanese glyph.
    /// 例えば、この分には１０００は全角数字が入ってます。
	var isZenkakuNumerical: Bool {
		return inRange(self, lowerBound: 0xFF10, upperBound: 0xFF19)
	}
	
	// MARK: - Japanese Specific Characters

    /// Some characters in the Japanese syllabary do not map directly to Roman representation.
	var isSpecificToJapanese: Bool {
		return inRange(self, lowerBound: 0x3040, upperBound: 0x30FF) || inRange(self, lowerBound: 0xFF01, upperBound: 0xFF9F) || isKuten || isTouten
	}
}
