import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/Pokemon/pokemon_controler.dart';
import 'package:techapp/PokemonDetail/pokemon_detail_screen.dart';
import 'package:techapp/Pokemon/pokemon_state.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Cache ảnh

import '../Model/pokemon_model.dart';

class PokemonScreen extends StatefulWidget {
  const PokemonScreen({super.key});
  @override
  State<PokemonScreen> createState() => _PokemonScreenState();
}

class _PokemonScreenState extends State<PokemonScreen> {
  final ScrollController _scrollController = ScrollController();
  final PokemonControler _controler = PokemonControler();
  List<Pokemon> _currentPokemons = [];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      _controler.fetchPokemon();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void detailPokemon(Pokemon pokemon) {
    _controler.selectPokemon(pokemon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Poke List'),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => _controler..getPokemonFromCache(),
        child: BlocListener<PokemonControler, PokemonState>(
          listener: (context, state) {
            if (state is SelectPokemonState) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PokemonDetailScreen(pokemon: state.selectedPokemon),
                ),
              ).then((_) {
                // Khi quay lại từ màn hình chi tiết (pop), reset selection để tránh lỗi
                _controler.cleanSelection();
                //trick to reload list
                _controler.currentListPokemons();
              });
            }
          },
          child: BlocBuilder<PokemonControler, PokemonState>(
            builder: (context, state) {
              if (state is PokemonLoadSuccess) {
                _currentPokemons = state.pokemons;
              }
              return Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      // Logic refresh của bạn
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(12),
                      controller: _scrollController,
                      // Nếu đang load failure hoặc success thì hiện list bình thường
                      // Nếu muốn hiện loading ở đáy khi phân trang, ta + 1 item
                      itemCount: _currentPokemons.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        // Item cuối cùng: Loading indicator cho phân trang (Paging)
                        if (index == _currentPokemons.length) {
                          // Chỉ hiện loading nhỏ ở dưới đáy nếu đang load thêm
                          return (state is PokemonLoading &&
                                  _currentPokemons.isNotEmpty)
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox.shrink(); // Ẩn đi nếu không load
                        }

                        final pokemon = _currentPokemons[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () => detailPokemon(pokemon),
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: pokemon.imageUrl ?? '',
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pokemon.name.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Tap for details',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // --- LAYER 2: LOADING OVERLAY (Hiển thị đè lên khi Loading toàn màn hình) ---
                  // Chỉ hiện khi chưa có dữ liệu nào (lần đầu vào app)
                  if (state is PokemonLoading && _currentPokemons.isEmpty)
                    Container(
                      color: Colors.white, // Nền trắng che hết
                      child: const Center(child: CircularProgressIndicator()),
                    )
                  // Hoặc nếu muốn hiện loading mờ đè lên list cũ (Optional)
                  else if (state is PokemonLoading &&
                      _currentPokemons.isNotEmpty)
                    // Bạn có thể bỏ đoạn này nếu chỉ muốn loading ở đáy list (paging)
                    const SizedBox.shrink(),

                  // --- LAYER 3: INITIAL STATE ---
                  if (state is PokemonInitial)
                    const Center(child: CircularProgressIndicator()),

                  // --- LAYER 4: ERROR STATE ---
                  if (state is PokemonLoadFailure && _currentPokemons.isEmpty)
                    Center(child: Text(state.message)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
