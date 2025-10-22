# 📚 MediaShelf

> **Your Personal Media Library Manager**

MediaShelf is a Flutter application for organizing and tracking your book collection. Search for books, build your personal library, rate and review, track reading progress—all stored locally for offline access.

---

## ✨ Features

- 🔍 **Search Books** – Find books using the Google Books API
- ➕ **Personal Library** – Save books to your offline collection
- ⭐ **Ratings & Reviews** – Rate books on a 5-star scale
- ❤️ **Favorites** – Mark and filter your favorite books
- 📝 **Notes** – Add personal notes to any book
- 📊 **Reading Status** – Track books as *Currently Reading*, *To Read*, *Read*, or *Unread*
- 🔄 **Sort & Filter** – Organize by title, author, rating, or date added
- 💾 **Offline-First** – All data stored locally with Hive

---

## 🛠️ Tech Stack

- **Flutter** `^3.7.2` – Cross-platform framework
- **Provider** `^6.1.5` – State management
- **Hive** `^2.2.3` & **Hive Flutter** `^1.1.0` – Local NoSQL database
- **Google Books API** – Book search and metadata
- **HTTP** `^1.4.0` – Network requests
- **Cached Network Image** `^3.4.1` – Image caching
- **Shared Preferences** `^2.5.3` – Key-value storage

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.7.2+
- Dart SDK
- Google Books API Key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Sy-Nipun04/media-shelf.git
   cd media-shelf
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Set up API key**
   - Create a `.env` file in the root directory
   - Add your Google Books API key:
     ```
     BOOKS_API_KEY=your_api_key_here
     ```

4. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 🗺️ Roadmap

### Short Term
- [ ] Dark mode support
- [ ] Import/export library data
- [ ] Reading statistics and insights
- [ ] ML-based book recommendations

### Future Vision 🔮
MediaShelf will expand to become a comprehensive media manager:

- **🎮 Video Games** – Track your gaming backlog (RAWG API)
- **🎬 Movies & TV** – Manage watchlists and viewing history (TMDB API)
- **🎵 Music & Albums** – Organize playlists and listening history (Spotify/Last.fm API)

---

## 👨‍💻 Author

**Sy-Nipun04**  
GitHub: [@Sy-Nipun04](https://github.com/Sy-Nipun04)  
Repository: [media-shelf](https://github.com/Sy-Nipun04/media-shelf)

---

## 📧 Support

Questions or issues? Open an issue on GitHub.
