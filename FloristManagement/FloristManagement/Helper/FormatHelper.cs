using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace FloristManagement.Helper
{
    public class FormatHelper
    {
        public string FormatId(int id)
        {
            return string.Format("{0:N0}", id);
        }
        public string ShortenParagraph(string paragraph, int maxWords)
        {
            string[] words = paragraph.Split(' ');
            if (words.Length <= maxWords)
            {
                return paragraph;
            }
            else
            {
                string[] shortenedWords = words.Take(maxWords).ToArray();
                return string.Join(" ", shortenedWords) + "...";
            }
        }
    }
}