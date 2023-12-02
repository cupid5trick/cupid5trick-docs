---
scope: learn
draft: true
created: 2022-08-01T03:08:03 (UTC +08:00)
tags: ['uuid','guid']
source: https://stackoverflow.com/questions/246930/is-there-any-difference-between-a-guid-and-a-uuid
author: HoylenHoylen
---

# Is there any difference between a GUID and a UUID? - Stack Overflow

> ## Excerpt
> I see these two acronyms being thrown around and I was wondering if there are any differences between a GUID and a UUID?

---
~The **simple answer** is: no difference, they are the same thing.~

**2020-08-20 Update**: While GUIDs (as used by Microsoft) and UUIDs (as defined by RFC4122) look similar and serve similar purposes, there are subtle-but-occasionally-important differences. Specifically, [some Microsoft GUID docs](https://docs.microsoft.com/en-us/windows/win32/msi/guid) allow GUIDs to contain any hex digit in any position, while RFC4122 requires certain values for the `version` and `variant` fields. Also, \[per that same link\], GUIDs should be all-upper case, whereas UUIDs [should be](https://www.rfc-editor.org/rfc/rfc4122#section-3) "output as lower case characters and are case insensitive on input". This can lead to incompatibilities between code libraries ([such as this](https://github.com/uuidjs/uuid/issues/511)).

(Original answer follows)

---

Treat them as a 16 byte (128 bits) value that is used as a unique value. In Microsoft-speak they are called GUIDs, but call them UUIDs when not using Microsoft-speak.

Even the authors of the UUID specification and Microsoft claim they are synonyms:

-   From the introduction to IETF [RFC 4122](https://datatracker.ietf.org/doc/html/rfc4122) "*A Universally Unique IDentifier (UUID) URN Namespace*": "a Uniform Resource Name namespace for UUIDs (Universally Unique IDentifier), also known as GUIDs (Globally Unique IDentifier)."
    
-   From the [ITU-T Recommendation X.667, ISO/IEC 9834-8:2004 International Standard](http://www.itu.int/ITU-T/studygroups/com17/oid.html): "UUIDs are also known as Globally Unique Identifiers (GUIDs), but this term is not used in this Recommendation."
    
-   And Microsoft even [claims](http://msdn.microsoft.com/en-us/library/cc246025%28v=PROT.13%29.aspx) a GUID is specified by the UUID RFC: "In Microsoft Windows programming and in Windows operating systems, a globally unique identifier (GUID), as specified in \[RFC4122\], is ... The term universally unique identifier (UUID) is sometimes used in Windows protocol specifications as a synonym for GUID."
    

But the **correct answer** depends on what the question means when it says "UUID"...

The first part depends on what the asker is thinking when they are saying "UUID".

Microsoft's claim implies that all UUIDs are GUIDs. But are all GUIDs real UUIDs? That is, is the set of all UUIDs just a proper subset of the set of all GUIDs, or is it the exact same set?

Looking at the details of the RFC 4122, there are four different "variants" of UUIDs. This is mostly because such 16 byte identifiers were in use before those specifications were brought together in the creation of a UUID specification. From section 4.1.1 of [RFC 4122](https://datatracker.ietf.org/doc/html/rfc4122), the four *variants* of UUID are:

1.  Reserved, Network Computing System backward compatibility
2.  The *variant* specified in RFC 4122 (of which there are five sub-variants, which are called "versions")
3.  Reserved, Microsoft Corporation backward compatibility
4.  Reserved for future definition.

According to RFC 4122, all UUID *variants* are "real UUIDs", then all GUIDs are real UUIDs. To the literal question "is there any difference between GUID and UUID" the answer is definitely no for RFC 4122 UUIDs: **no difference** (but subject to the second part below).

But not all GUIDs are *variant* 2 UUIDs (e.g. Microsoft COM has GUIDs which are variant 3 UUIDs). If the question was "is there any difference between GUID and variant 2 UUIDs", then the answer would be yes -- they can be different. Someone asking the question probably doesn't know about *variants* and they might be only thinking of *variant* 2 UUIDs when they say the word "UUID" (e.g. they vaguely know of the MAC address+time and the random number algorithms forms of UUID, which are both *versions* of *variant* 2). In which case, the answer is **yes different**.

So the answer, in part, depends on what the person asking is thinking when they say the word "UUID". Do they mean variant 2 UUID (because that is the only variant they are aware of) or all UUIDs?

The second part depends on which specification being used as the definition of UUID.

If you think that was confusing, read the [ITU-T X.667 ISO/IEC 9834-8:2004](http://www.itu.int/ITU-T/studygroups/com17/oid.html) which is supposed to be aligned and fully technically compatible with [RFC 4122](https://datatracker.ietf.org/doc/html/rfc4122). It has an extra sentence in Clause 11.2 that says, "All UUIDs conforming to this Recommendation | International Standard shall have variant bits with bit 7 of octet 7 set to 1 and bit 6 of octet 7 set to 0". Which means that only *variant* 2 UUID conform to that Standard (those two bit values mean *variant* 2). If that is true, then not all GUIDs are conforming ITU-T/ISO/IEC UUIDs, because conformant ITU-T/ISO/IEC UUIDs can only be *variant* 2 values.

Therefore, the real answer also depends on which specification of UUID the question is asking about. Assuming we are clearly talking about all UUIDs and not just variant 2 UUIDs: there is **no difference** between GUID and IETF's UUIDs, but **yes difference** between GUID and *conforming* ITU-T/ISO/IEC's UUIDs!

**Binary encodings could differ**

When encoded in binary (as opposed to the human-readable text format), the GUID [may be stored](http://en.wikipedia.org/wiki/Globally_unique_identifier) in a structure with four different fields as follows. This format differs from the \[UUID standard\] [8](https://www.rfc-editor.org/rfc/rfc4122) only in the byte order of the first 3 fields.

```bash
Bits  Bytes Name   Endianness  Endianness
                   (GUID)      RFC 4122

32    4     Data1  Native      Big
16    2     Data2  Native      Big
16    2     Data3  Native      Big
64    8     Data4  Big         Big
```
