module JellyFish
	using Libdl: find_library

	export jaro_winkler, jaro_distance, hamming_distance, 
		levenshtein_distance, damerau_levenshtein_distance, soundex, metaphone, 
		match_rating_codex, match_rating_comparison, nysiis
	const _jellyfishlib = find_library(["jellyfish"], [joinpath(@__DIR__, "..", "deps")])

	macro _calls1s2type(func, returntype, s1, s2)
		:(ccall(($(esc(func)), _jellyfishlib), $(esc(returntype)), (Ptr{Cchar}, Ptr{Cchar}), $(esc(s1)), $(esc(s2))))
	end

	function jaro_winkler(s1::String, s2::String)
		ccall((:jaro_winkler, _jellyfishlib), Cdouble, (Ptr{Cchar}, Ptr{Cchar}, Bool), s1, s2, false)
	end

	function jaro_distance(s1::String, s2::String)
		@_calls1s2type(:jaro_distance, Cdouble, s1, s2)
	end

	function hamming_distance(s1::String, s2::String)
		convert(Int, @_calls1s2type(:hamming_distance, Csize_t, s1, s2))
	end

	function levenshtein_distance(s1::String, s2::String)
		@_calls1s2type(:levenshtein_distance, Cint, s1, s2)
	end

	function damerau_levenshtein_distance(s1::String, s2::String)
		@_calls1s2type(:damerau_levenshtein_distance, Cint, s1, s2)
	end

	# for some reason doesn't work:
	function _callstr(func::Symbol, s::String)
		r = ccall((func, _jellyfishlib), Ptr{Cchar}, (Ptr{Cchar},), s)
		unsafe_string(r)
	end

	function soundex(s::String)
		# _callstr(:soundex, s)
		r = ccall((:soundex, _jellyfishlib), Ptr{Cchar}, (Ptr{Cchar},), s)
		unsafe_string(r)
	end

	function metaphone(s::String)
		# _callstr(:metaphone, s)
		r = ccall((:metaphone, _jellyfishlib), Ptr{Cchar}, (Ptr{Cchar},), s)
		unsafe_string(r)
	end

	function match_rating_codex(s::String)
		# _callstr(:match_rating_codex, s)
		r = ccall((:match_rating_codex, _jellyfishlib), Ptr{Cchar}, (Ptr{Cchar},), s)
		unsafe_string(r)
	end

	function match_rating_comparison(s1::String, s2::String)
		@_calls1s2type(:match_rating_comparison, Bool, s1, s2)
	end

	function nysiis(s::String)
		# _callstr(:nysiis, s)
		r = ccall((:nysiis, _jellyfishlib), Ptr{Cchar}, (Ptr{Cchar},), s)
		unsafe_string(r)
	end
end
