import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techapp/Pokemon/pokemon_controller.dart';
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
  final PokemonController _controler = PokemonController();

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
        child: BlocListener<PokemonController, PokemonState>(
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
          child: BlocBuilder<PokemonController, PokemonState>(
            builder: (context, state) {
              List<Pokemon> pokemons = [];
              bool isLoadingMore = false;

              if (state is PokemonLoadSuccess) {
                pokemons = state.pokemons;
                isLoadingMore = state.loadingFlag;
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
                      itemCount: pokemons.length + 1,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (index == pokemons.length) {
                          return (isLoadingMore)
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }

                        final pokemon = pokemons[index];
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
                  if (state is PokemonLoading && pokemons.isEmpty)
                    Container(
                      color: Colors.white,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                  if (state is PokemonInitial)
                    const Center(child: CircularProgressIndicator()),
                  if (state is PokemonLoadFailure && pokemons.isEmpty)
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
