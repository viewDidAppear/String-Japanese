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

import Foundation

extension UniChar {

	// MARK: - UNICODE Helper ユニコードのヘルパー
	
	private func inRange(_ char: UniChar, lowerBound: UniChar, upperBound: UniChar) -> Bool {
		return (lowerBound <= char) && (char <= upperBound)
	}
	
	// MARK: - カタカナ、平仮名 | Japanese Syllabic Character Set
	
	var isHiragana: Bool {
		return inRange(self, lowerBound: 0x3040, upperBound: 0x309F)
	}
	
	var isKatakana: Bool {
		return inRange(self, lowerBound: 0x30A0, upperBound: 0x30FF) && (self != 0x30FB || inRange(self, lowerBound: 0xFF66, upperBound: 0xFF9F))
	}
	
	// MARK: - 漢字 | Chinese-origin Characters
	
	var isKanji: Bool {
		return (inRange(self, lowerBound: 0x2E80, upperBound: 0x2EFF) || inRange(self, lowerBound: 0x2F00, upperBound: 0x2FDF) || inRange(self, lowerBound: 0x4E00, upperBound: 0x9FAF))
	}
	
	// MARK: - 句点、読点、空白 | Circular Period, Comma, Space
	
	var isKuten: Bool {
		return self == 0x3001 || self == 0xFF64 || self == 0xFF0E
	}
	
	var isTouten: Bool {
		return self == 0x3002 || self == 0xFF61 || self == 0xFF0C
	}
	
	var isKuuhaku: Bool {
		return self == 0x3000
	}
	
	// MARK: - 半角カタカナ、全角ローマ字、数字集合 | Half-width Katakana, Full-width Romaji, Full-width Numeric
	
	var isHankakuKatakana: Bool {
		return inRange(self, lowerBound: 0xFF61, upperBound: 0xFF9F)
	}
	
	var isZenkakuRomaji: Bool {
		return inRange(self, lowerBound: 0xFF01, upperBound: 0xFF5E)
	}
	
	var isZenkakuNumerical: Bool {
		return inRange(self, lowerBound: 0xFF10, upperBound: 0xFF19)
	}
	
	// MARK: - 日本語特異的字 | Japanese Specific Characters
	
	var isSpecificToJapanese: Bool {
		return inRange(self, lowerBound: 0x3040, upperBound: 0x30FF) || inRange(self, lowerBound: 0xFF01, upperBound: 0xFF9F) || isKuten || isTouten
	}
}
